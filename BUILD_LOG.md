# BunkerAI-RT7 Alaska Edition — Full Build Log

*Oukitel RT7 Titan 5G | SanDisk Extreme 512GB | Interior Alaska*

---

## Build Overview

**Mission:** Build a fully self-contained, air-gapped survival intelligence terminal on the Oukitel RT7 Titan 5G that exceeds the commercial BunkerAI "BOB" tablet in every operationally relevant category — battery life, ruggedness, AI capability, and open architecture — at roughly half the cost.

**Design constraints that govern every decision:**

* **Zero-Dark-Access:** No internet connection required for any function. No towers, no cloud, no cellular.
* **Single Interface:** All tools accessible from one unified launcher. One purpose, one screen.
* **Open Architecture:** No locked models, no proprietary apps, no vendor dependency.
* **Alaska-Hardened:** Specs, content, maps, and use cases tuned for Interior Alaska — extreme cold, long winter nights, remote terrain, grid-down scenarios.

**Setup machine:** MacBook Air (macOS)
**Transfer method:** Direct exFAT card copy via Mac (not ADB) — significantly faster for large transfers

---

## Phase 0 — First Boot Protocol

*Completed: March 16, 2026*

### Hardware State at Start

| Item | Detail |
| --- | --- |
| Device | Oukitel RT7 Titan 5G |
| Serial | REDACTED — device-specific identifier intentionally omitted from public repo |
| Chipset | MediaTek MT6853 / Dimensity 720 (ARM64) |
| RAM | 12GB LPDDR4X physical |
| Storage | 256GB internal |
| Firmware | OUKITEL_RT7_TITAN_5G_EEA_A15_V07_20250910 |
| OS | Android 15 |
| Firmware Variant | EEA (European Economic Area) with NFC |

### First Boot Sequence

The RT7 was powered on for the first time and taken through Android's initial setup with deliberate choices. **The device was kept offline and account-free throughout.**

> Connecting to Wi-Fi or signing into Google during first boot triggers background syncs, account bindings, and telemetry. The device was kept offline and account-free to avoid these complications.

| Setup Screen | Action | Reason |
| --- | --- | --- |
| Language | English | Standard |
| Wi-Fi | Skipped — no network connected | Prevent background sync on first boot |
| Google Account | Skipped | Prevent account binding and cloud backup |
| Google Services | All declined | Eliminate telemetry at OS level |
| PIN | Set | Required for ADB auth and kiosk lockdown |
| Oukitel screens | All skipped | No manufacturer cloud services needed |

### ADB Setup on MacBook Air

```
# Install Homebrew (if not present)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ADB
brew install android-platform-tools

# Verify
adb version
# Expected: Android Debug Bridge version 1.0.41 or higher
```

### Enable USB Debugging on RT7

1. Settings → About Tablet → Build Number — tap 7 times
2. Settings → Developer Options → USB Debugging → **ON**
3. Settings → Developer Options → Stay Awake → **ON** (keeps screen on during transfers)
4. Connect RT7 to Mac via Anker PowerLine III Flow USB-C
5. On RT7: allow the connection, select "Always allow from this computer"

```
# Verify connection
adb devices
# Expected: <device_serial>   device
# If "unauthorized": check RT7 screen for Allow popup
```

### Pre-Build Package Snapshot

Before any changes, export the complete package list as the permanent before-state record:

```
adb shell pm list packages > ~/Desktop/rt7_packages.txt
```

> Keep this file permanently. It is the reference for any restore operation if something breaks.

---

## Phase 0b — Debloat Attempt

*Completed (and undone): March 16, 2026*

> **⚠️ SKIP THIS PHASE. The debloat caused a boot loop. This phase is documented for the community record, not as a step to repeat. The build works without debloat. Jump to Phase 0c if you need recovery, or Phase 1 for a clean start.**

### What Was Attempted

ADB debloat using `adb shell pm uninstall --user 0` to remove Google consumer apps, Google Assistant, Oukitel manufacturer preloads, and Android system bloat (screen savers, live wallpaper, SIM toolkit, print spooler, NFC service).

The `--user 0` flag hides packages from the primary user profile without deleting them from the system partition — theoretically reversible. Every removal was verified against the package snapshot first.

**Why it seemed safe:** The `--user 0` method had worked on other Android devices without issues.

### What Broke It

Removing `com.android.nfc` and one or more of the following system packages triggered a boot loop:

```
com.android.nfc
com.android.printspooler
com.android.dreams.basic
com.android.wallpaper.livepicker
com.android.stk
com.android.soundrecorder
com.android.dreams.phototable
```

**Root cause:** On MediaTek MT6853 / Android 15 EEA builds, `com.android.nfc` appears to be coupled to a hardware initialization service that runs at boot before Android fully loads. Hiding it via `--user 0` caused the init sequence to fail.

**Result:** Device shows "Software corrupted — press power to boot" on every subsequent boot. Factory reset does not fix it — the corruption is in the `super.img` system partition, not userdata.

### What NOT to Debloat (If You Attempt This on Another Device)

Never remove these packages on the RT7 Titan:

| Package | Risk |
| --- | --- |
| `com.android.nfc` | **Causes boot loop on MT6853 EEA** |
| `com.google.android.gms` | Briar, Seek, others reference GMS at runtime |
| `com.android.camera2` | IR night vision — core build capability |
| `com.android.settings` | System becomes unconfigurable |
| `com.android.bluetooth` | Required for Briar + Meshtastic |
| `android.hardware.location.*` | Navigation foundation |

### Lesson

The Lawnchair launcher configuration (Phase 0f / Phase 5) achieves the same clean interface without touching the system partition. It locks the device to approved apps, hides everything else, and removes the interface clutter. The debloat adds nothing the launcher doesn't also deliver — but it can brick the device.

**Do not debloat the RT7 Titan.**

---

## Phase 0c — Firmware Recovery

*Completed: March 17, 2026*

### The Problem

Device in boot loop. Factory reset failed (userdata wipe can't fix system partition corruption). Bootloader locked. No root access. Nine recovery attempts exhausted before finding a path forward.

### Recovery Attempts — Full Log

#### Attempt 1 — Factory Reset via Recovery Mode

`adb reboot recovery` → Wipe data / Factory reset → Reboot
**Result: FAILED.** Factory reset only wipes userdata. Corruption is in `super.img`. Device returned to corrupt screen.

#### Attempt 2 — BROM Mode Entry (Multiple Methods)

BROM (Boot ROM) is the lowest-level MediaTek recovery mode — bypasses the bootloader entirely.

Methods tried: Volume Down + plug USB, Volume Up + plug USB, Volume Up + Volume Down + plug USB, plug first then Volume Down, all held 10–15 seconds.

**Result: FAILED.** Software-only BROM entry did not work on this device.

*Note: mtkclient `devices` returned a Wiko Lenny 4 entry — this was a cached entry in mtkclient's local database, not a live device. The RT7 was never detected by mtkclient via software-only methods.*

#### Attempt 3 — Fastboot Flash (Full Partition Set)

`adb reboot bootloader` → `fastboot flash vbmeta vbmeta.img`
**Result: FAILED.** `Writing 'vbmeta_a' FAILED (remote: 'not allowed in locked state')` — bootloader locked.

#### Attempt 4 — Fastboot OEM Unlock

`fastboot flashing unlock`
First attempt: `FAILED (remote: 'Unlock operation is not allowed')`
Second attempt: `OKAY [9.208s]` — appeared to succeed.
Follow-up: `fastboot getvar unlocked` → `unlocked: no`

**Result: FAILED.** The unlock command was accepted but didn't persist. `oem_unlock_enabled` was never set to 1 in Developer Options before the device stopped booting.

#### Attempt 5 — ADB Settings Command to Enable OEM Unlock

```
adb shell settings put global oem_unlock_enabled 1
adb shell settings get global oem_unlock_enabled
```

**Result: FAILED.** Command ran without error but didn't persist after reboot.

#### Attempt 6 — Legacy Fastboot OEM Unlock Command

`fastboot oem unlock`
**Result: FAILED.** `FAILED (remote: 'unknown command')`

#### Attempt 7 — Flash boot.img Only (Locked Bootloader)

`fastboot flash boot boot.img`
**Result: FAILED.** `FAILED (remote: 'not allowed in locked state')`

#### Attempt 8 — ADB Root / DD Write to Block Devices

**Result: FAILED.** Production build, no su binary. Block device writes require root.

#### Attempt 9 — Recovery Mode ADB Root

**Result: Inconclusive.** Timed out before commands could be executed.

### Resolution — BROM Mode via PCB Test Point

All software-only methods failed. The only confirmed recovery path for a locked-bootloader RT7 Titan with a corrupted `super.img` required physical PCB access.

Entry into BROM (Boot ROM) mode was achieved by shorting a physical test point on the RT7 motherboard — requiring partial disassembly. Once BROM mode was confirmed, mtkclient on an M1 MacBook Air was used to communicate with the device at the BROM level, and SP Flash Tool flashed the full firmware image including `super.img`, restoring the system partition to a clean baseline.

> **This is the only confirmed recovery path.** If you brick an RT7 Titan with a locked bootloader, you need physical PCB access and mtkclient. There is no software-only recovery.

**Available firmware files used:**

| File | Version | Date |
| --- | --- | --- |
| TP758_OQ_P07_NFC_6853_TO_EEA_V1.4.8_S251017.zip | V1.4.8 | Oct 2025 |

Key files confirmed present in ZIP:

* `MT6853_Android_scatter.txt` — partition map
* `super.img` — 5.1GB — contains the Android OS
* `preloader_tp758_oq_p07_nfc_6853_t0_eea.bin`
* All partition images (boot, vbmeta, dtbo, gz, lk, etc.)

### Post-Recovery Device State

| Item | Status |
| --- | --- |
| Firmware | V1.4.8 clean baseline |
| Android | 15 — fresh install |
| USB Debugging | Re-enabled |
| ADB Connection | Working — MacBook Air confirmed |

---

## Phase 0d — Debloat Phase 1 (UAD-NG)

*Completed: March 23, 2026*

**Status: ✅ COMPLETE — Silent State achieved**

> This phase replaced the failed manual ADB debloat attempt (Phase 0b). UAD-NG's risk-rated GUI and per-package description database eliminated the guesswork that caused the previous boot loop.

### Objective

Achieve a "Silent State" — remove all non-essential manufacturer bloatware, Google telemetry, and persistent background services — without touching boot-critical system packages. Primary goals: maximize 32,000mAh battery life and ensure full 24GB RAM availability for offline AI models.

### Tooling Stack

| Tool | Role |
| --- | --- |
| UAD-NG (Universal Android Debloater — Next Generation) | Risk-rated GUI — categorizes packages as Recommended / Advanced / Expert / Unsafe |
| Terminal (Zsh) | CLI override for packages outside UAD-NG database |
| ADB (Android Debug Bridge) | Device communication layer |

### Procedure A — Initial GUI Pass (UAD-NG)

UAD-NG was launched via Terminal to ensure it inherited the ADB environment:

```
universal-android-debloater
```

Pre-flight package export before any removal:

```
adb shell pm list packages -f > ~/Desktop/RT7_Factory_Baseline.txt
```

**Selection criteria:** Packages marked "Recommended" or "Advanced" that did not impact core hardware (GPS, IR Camera, Bluetooth, NFC). Oukitel-specific packages lacked community definitions in the UAD-NG database for Android 15 — these required manual CLI override.

**MediaTek safety rule:** For any `com.mediatek.*` or `com.wtk.*` package, the UAD-NG description field was checked before action. Any package whose description referenced "Boot," "Init," "NVRAM," or "Modem" was immediately whitelisted. This is the direct lesson from the Phase 0b boot loop.

### Procedure B — Dumpsys Identification Drill

To identify stubborn or hidden manufacturer apps appearing on the home screen, the following command was run while the target app was in focus:

```
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'
```

This returned the exact package name (e.g., `com.ddu.ai`) for surgical removal.

### Procedure C — Deep Freeze Persistence Kill-Chain

Standard `pm uninstall --user 0` commands failed on several Oukitel packages due to "Watcher" services in the firmware that trigger re-installs on reboot. The following five-step sequence was developed to break the self-repair loop permanently:

```
adb shell am force-stop [package.name]                     # 1. Force Stop
adb shell pm clear [package.name]                          # 2. Clear Data
adb shell pm disable-user --user 0 [package.name]          # 3. Disable
adb shell pm hide [package.name]                           # 4. Mask/Hide
adb shell pm uninstall --user 0 [package.name]             # 5. Uninstall
```

### Package Disposition Registry

| App Name | Package ID | Method | Result |
| --- | --- | --- | --- |
| Google Kids Space | `com.google.android.apps.kids.home` | UAD-NG Uninstall | Purged |
| OKGame Center | `com.oukitel.gamecenter` | Deep Freeze Kill-Chain | Purged |
| Oukitel AI | `com.ddu.ai` | Deep Freeze Kill-Chain | Purged |
| Oukitel Market | `com.ddu.appstore` | Deep Freeze Kill-Chain | Purged |
| Oukitel Weather | `com.ddu.android.weather` | Deep Freeze Kill-Chain | Purged |
| Customer Center | `com.easycontrol.customercenter` | Mask/Hide | Hidden |
| Tappic | `com.hebs.tappic` | UAD-NG Uninstall | Purged |

### Critical Whitelist — DO NOT REMOVE

| Package | Reason Retained |
| --- | --- |
| `com.mediatek.ygps` | Satellite acquisition — essential for Interior Alaska GPS |
| `com.mediatek.camera` | IR Night Vision sensor driver |
| `com.google.android.permissioncontroller` | Required for offline app permission grants |
| `com.wtk.factory` | Hardware calibration and sensor management |

### Emergency Restoration Procedure

If any removed package causes hardware instability, restore without factory reset:

UAD-NG: Change status filter from "Installed" to "Uninstalled" → select package → click Restore.

CLI backup method:

```
adb shell pm install-existing [package.name]
```

---

## Phase 0f — Launcher Swap (Nova → Lawnchair)

*Completed: March 25, 2026*

**Status: ✅ COMPLETE**

### Decision

Nova Launcher served as the System Anchor during Phase 0d debloat operations — it was side-loaded to suppress the Oukitel stock launcher's bloatware self-repair behavior. It was not suitable as the permanent launcher for this build.

| Disqualifying Factor | Detail |
| --- | --- |
| Development abandoned | Original dev team laid off after acquisition; co-founder departed September 2025 |
| No future Android compatibility guaranteed | No active development means future OS updates may break it |
| Ads in free app drawer | Violates zero-distraction mission interface requirement |
| Privacy opt-out non-functional | "Do Not Sell My Data" setting confirmed broken in paid Prime version |
| Telemetry posture failure | A survival terminal with a deliberate air-gap posture cannot run a launcher with non-functional privacy controls |

Lawnchair is open source (AOSP Launcher3 base), actively maintained, carries no telemetry, and provides all required features (gestures, app hiding, drawer groups) at no cost.

### APK Verification

| Field | Value |
| --- | --- |
| Version | 15 Beta 2.1 |
| Release Date | March 1, 2026 |
| Source | <https://github.com/LawnchairLauncher/lawnchair/releases> |
| SHA256 | `64a52605c299a7af9eeaafbf04a13c6e617f91c5930c8c160a3e23ab0579a6e6` |
| Verified on Mac | `shasum -a 256 lawnchair.apk` — confirmed match prior to install |
| Install method | ADB sideload — no Play Store dependency |
| Package name | `app.lawnchair` |

### Installation Procedure

```
# Step 1 — Install Lawnchair alongside Nova (Nova still active)
adb install lawnchair.apk

# Step 2 — Switch default launcher (on-device)
# Settings → Apps → Default Apps → Home App → Lawnchair

# Step 3 — Uninstall Nova
adb shell pm uninstall com.teslacoilsw.launcher

# Step 4 — Verify
adb shell pm list packages | grep lawnchair   # Expected: package:app.lawnchair
adb shell pm list packages | grep tesla        # Expected: no output
```

> Note: Step 2 must be performed on the device itself — Android 15 requires user confirmation for default app changes and will not accept it via ADB.

---

## Phase 1 — Content Download

*Completed: March 21–22, 2026*

All content was downloaded to the MacBook Air across two staging drives before transfer to the RT7.

### Staging Drive Setup

| Drive | Label | Format | Capacity | Used |
| --- | --- | --- | --- | --- |
| Drive 1 | UNTITLED | ExFAT | 159GB | ~149GB |
| Drive 2 | Bunker | ExFAT | 112GB | ~80GB |

### UNTITLED Drive — Content

**Root:** `/Volumes/UNTITLED/BunkerAI/`

#### Core Reference ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
| --- | --- | --- |
| `wikipedia_en_all_maxi_2025-08.zim` | 111GB | Full English Wikipedia with images. Transfer last. |
| `wikibooks_en_all_maxi_2026-01.zim` | 5.1GB | Repair manuals, field guides, technical how-tos |
| `wikiversity_en_all_maxi_2026-02.zim` | 2.2GB | Structured courses — science, engineering, skills |
| `wikivoyage_en_all_maxi_2026-03.zim` | 1.0GB | Geography, routes, regional reference |

#### Medical ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
| --- | --- | --- |
| `wikipedia_en_medicine_maxi_2026-01.zim` | 2.0GB | Full medical Wikipedia with images |
| `medlineplus.gov_en_all_2025-01.zim` | 1.8GB | NIH — symptoms, drugs, treatments (non-clinician language) |
| `fas-military-medicine_en_2025-06.zim` | 78MB | Military field medicine — austere environment trauma care |
| `nhs.uk_en_medicines_2025-12.zim` | 16MB | NHS drug reference — dosing, interactions, contraindications |
| `wwwnc.cdc.gov_en_all_2024-11.zim` | 170MB | CDC disease and public health reference |

#### Military & Survival ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
| --- | --- | --- |
| `armypubs_en_all_2024-12.zim` | 7.7GB | Complete Army field manuals and doctrine |
| `outdoors.stackexchange.com_en_all_2026-02.zim` | 136MB | Wilderness survival, cold weather ops, Interior Alaska conditions |
| `solar.lowtechmagazine.com_mul_all_2025-01.zim` | 668MB | Low-tech practical solutions — water, power, food preservation |

#### Repair & Construction ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
| --- | --- | --- |
| `ifixit_en_all_2025-12.zim` | 3.3GB | Step-by-step repair guides with photos |
| `diy.stackexchange.com_en_all_2026-02.zim` | 1.9GB | Home repair, construction, building |
| `mechanics.stackexchange.com_en_all_2026-02.zim` | 323MB | Vehicle repair, engines, maintenance |
| `woodworking.stackexchange.com_en_all_2026-02.zim` | 100MB | Joinery, construction from raw timber |

#### Communications & Electronics ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
| --- | --- | --- |
| `ham.stackexchange.com_en_all_2026-02.zim` | 72MB | Ham radio, antennas, emergency comms — supports Meshtastic layer |
| `electronics.stackexchange.com_en_all_2026-02.zim` | 3.9GB | Circuits, components, building from scratch |
| `physics.stackexchange.com_en_all_2026-02.zim` | 1.7GB | Foundational science for engineering applications |

#### AI Model Files → `/Volumes/UNTITLED/BunkerAI/Models/`

| File | Size | Notes |
| --- | --- | --- |
| `Phi-3-mini-4k-instruct-q4.gguf` | 2.2GB | Primary model — 3.8B params, Q4 quantization, MIT licensed |
| `Phi-3.5-mini-instruct-Q4_K_M.gguf` | 2.2GB | Secondary model — improved reasoning, same footprint |

Source: Microsoft / Bartowski on HuggingFace.

```
# Download Phi-3.5 Mini via HuggingFace CLI
huggingface-cli download bartowski/Phi-3.5-mini-instruct-GGUF \
  --include "Phi-3.5-mini-instruct-Q4_K_M.gguf" --local-dir ~/BunkerAI/Models/
```

#### Maps & Navigation → `/Volumes/UNTITLED/BunkerAI/Maps/`

| File | Size | Notes |
| --- | --- | --- |
| `OsmAnd-android-full-arm64.apk` | 196MB | ARM64 build — required for RT7's Dimensity 720 |
| `Us_alaska_northamerica_2.obf.zip` | 232MB | Complete Alaska OpenStreetMap — roads, trails, POIs, waterways |

#### ADFG Alaska Reference PDFs → `/Volumes/UNTITLED/BunkerAI/ADFG/`

| File | Size | Notes |
| --- | --- | --- |
| `alaska_hunting_regs_2025-2026.pdf` | 9.0MB | Complete Alaska hunting regulations — 144 pages |
| `GMU20_interior_alaska_2025-2026.pdf` | 1.0MB | Game Management Unit 20 — Fairbanks / Interior Alaska AO |
| `subsistence_fishing_regs_2025-2026.pdf` | 1.1MB | Statewide subsistence fishing regulations |
| `subsistence_hunt_supplement_2025-2026.pdf` | 1.1MB | Tier I, II, Community Harvest permits — Interior Alaska |

---

### Bunker Drive — Content

**Root:** `/Volumes/Bunker/BunkerAI/`

#### Project Gutenberg LCC Volumes → `/Volumes/Bunker/BunkerAI/ZIM/gutenberg/`

| File | Size | Subject |
| --- | --- | --- |
| `gutenberg_en_lcc-q_2026-03.zim` | 17GB | Science — biology, botany, zoology, natural history, geology |
| `gutenberg_en_lcc-t_2026-03.zim` | 12GB | Technology — engineering, construction, forge work, masonry |
| `gutenberg_en_lcc-a_2026-03.zim` | 9.1GB | General Works — encyclopedias, almanacs, reference collections |
| `gutenberg_en_lcc-g_2026-03.zim` | 7.5GB | Geography — exploration, wilderness travel, indigenous land use |
| `gutenberg_en_lcc-s_2026-03.zim` | 4.2GB | Agriculture — farming, animal husbandry, food preservation, forestry |
| `gutenberg_en_lcc-r_2026-03.zim` | 1.9GB | Medicine — pre-modern medical texts, herbal medicine, wound management |
| `gutenberg_en_lcc-u_2026-03.zim` | 1.2GB | Military Science — field craft, fortification, logistics, tactics |

#### CD3WD Pre-Industrial Knowledge ISOs → `/Volumes/Bunker/BunkerAI/CD3WD/`

Six DVD ISO files (~26GB total).

| File | Size |
| --- | --- |
| `1001_cd3wd.iso` | 4.3GB |
| `1002_cd3wd.iso` | 4.3GB |
| `1003_cd3wd.iso` | 4.3GB |
| `1004_cd3wd.iso` | 4.3GB |
| `1005_cd3wd.iso` | 4.3GB |
| `1006_cd3wd.iso` | 4.4GB |

> **Format note:** CD3WD files are ISO disk images, not ZIM files. They don't open in Kiwix. Use Amaze File Manager to browse ISO contents directly.

#### Additional Stack Exchange ZIM Files → `/Volumes/Bunker/BunkerAI/ZIM/stackExchange/`

| File | Size | Notes |
| --- | --- | --- |
| `cooking.stackexchange.com_en_all_2026-02.zim` | 226MB | Food prep, preservation, ingredient substitutions |
| `gardening.stackexchange.com_en_all_2026-02.zim` | 882MB | Vegetable cultivation, soil management — Interior Alaska conditions |
| `sustainability.stackexchange.com_en_all_2026-02.zim` | 26MB | Off-grid systems, long-term self-sufficiency |
| `biology.stackexchange.com_en_all_2026-02.zim` | 403MB | Plant/animal ID, ecology, physiology |
| `engineering.stackexchange.com_en_all_2026-02.zim` | 242MB | Mechanical, civil, electrical, structural Q&A |

#### APK Files → `/Volumes/Bunker/BunkerAI/APKs/`

| File | Size | Notes |
| --- | --- | --- |
| `kiwix-3.10.0.apk` | 94MB | Kiwix Reader — must be installed before any ZIM is accessible |
| `VLC-Android-3.6.2-arm64-v8a.apk` | 45MB | VLC — ARM64 build for RT7 processor |

---

### Content Summary

| Category | Size |
| --- | --- |
| Wikipedia + Core ZIMs (UNTITLED) | ~120GB |
| Medical ZIMs (UNTITLED) | ~6GB |
| Military & Survival ZIMs (UNTITLED) | ~9GB |
| Repair & Construction ZIMs (UNTITLED) | ~6GB |
| Communications ZIMs (UNTITLED) | ~6GB |
| AI Models (UNTITLED) | ~4.4GB |
| Maps & Navigation (UNTITLED) | ~428MB |
| ADFG PDFs (UNTITLED) | ~12MB |
| Gutenberg LCC Volumes (Bunker) | ~53GB |
| CD3WD ISOs (Bunker) | ~26GB |
| Stack Exchange adds (Bunker) | ~1.8GB |
| APKs (Bunker) | ~139MB |
| **GRAND TOTAL** | **~244GB** |
| **MicroSD headroom remaining** | **~232GB** |

---

## Phase 2 — MicroSD Transfer

*Completed: March 25–26, 2026*

**Status: ✅ COMPLETE — 229GB confirmed on card**

### Transfer Method

Transfer was performed via **direct exFAT card copy on Mac** — significantly faster than ADB push for large files. The SanDisk Extreme 512GB was formatted on Mac using diskutil before any files were copied.

> **Why not ADB?** ADB push has protocol overhead that slows large transfers considerably. Direct card copy at Mac-to-card speeds saved several hours on the 244GB total transfer.

### Card Preparation

```
# Verify card device identifier
diskutil list
# SanDisk Extreme 512GB appeared as /dev/disk6 — Windows_NTFS (factory format)

# Reformat as exFAT with MBR partition scheme (Android-compatible)
diskutil eraseDisk ExFAT BUNKERAI MBRFormat /dev/disk6

# Verify mount
ls /Volumes/BUNKERAI/
```

### Folder Structure Created

```
mkdir -p /Volumes/BUNKERAI/Kiwix
mkdir -p /Volumes/BUNKERAI/AI_Models
mkdir -p /Volumes/BUNKERAI/BunkerAI/ADFG
mkdir -p /Volumes/BUNKERAI/BunkerAI/CD3WD
mkdir -p /Volumes/BUNKERAI/APKs
mkdir -p /Volumes/BUNKERAI/USGS_Topos/Interior_Alaska
```

### Transfer Sequence (Completed)

All transfers performed via `cp -rv` from staging drives to card:

| Step | Content | Method | Status |
| --- | --- | --- | --- |
| 1 | AI Models (~4.4GB) | `cp -rv /Volumes/UNTITLED/BunkerAI/Models/ /Volumes/BUNKERAI/AI_Models/` | ✅ |
| 2 | ADFG PDFs (~12MB) | `cp -rv /Volumes/UNTITLED/BunkerAI/ADFG/ /Volumes/BUNKERAI/BunkerAI/ADFG/` | ✅ |
| 3 | APKs — OsmAnd, Alaska OBF, Kiwix, VLC | `cp -rv` from staging drives | ✅ |
| 4 | APKs — Meshtastic, Briar, Amaze, ChatterUI | `curl -L` direct download to card | ✅ |
| 5 | ZIMs — UNTITLED (18 files, ~32GB) | Individual `cp -rv` per file | ✅ |
| 6 | Gutenberg LCC ZIMs (~53GB) | `cp -rv /Volumes/Bunker/BunkerAI/ZIM/gutenberg/` | ✅ |
| 7 | Stack Exchange ZIMs — Bunker (~1.8GB) | `cp -rv /Volumes/Bunker/BunkerAI/ZIM/stackExchange/` | ✅ |
| 8 | CD3WD ISOs (~26GB) | `cp -rv /Volumes/Bunker/BunkerAI/CD3WD/` | ✅ |
| 9 | Wikipedia (111GB) | `cp -rv` — overnight transfer | ✅ |

### Final Card Inventory

```
/Volumes/BUNKERAI/
├── AI_Models/          Phi-3-mini-4k-instruct-q4.gguf (2.2GB)
│                       Phi-3.5-mini-instruct-Q4_K_M.gguf (2.2GB)
├── APKs/               OsmAnd-android-full-arm64.apk (196MB)
│                       Us_alaska_northamerica_2.obf.zip (232MB)
│                       kiwix-3.10.0.apk (94MB)
│                       VLC-Android-3.6.2-arm64-v8a.apk (45MB)
│                       meshtastic.apk (34MB)
│                       briar.apk (48MB)
│                       amaze.apk (12MB)
│                       chatterui.apk (34MB)
├── BunkerAI/
│   ├── ADFG/           4 Alaska hunting/fishing/subsistence PDFs
│   └── CD3WD/          1001–1006_cd3wd.iso (6 files, ~26GB)
├── Kiwix/              26 ZIM files including Wikipedia (total ~211GB)
└── USGS_Topos/
    └── Interior_Alaska/ (pending — topos not yet downloaded)
```

**Total on card: 229GB of 476GB usable (~48%). ~247GB headroom remaining.**

### Virtual RAM — Set Before Card Insertion

> Settings → RAM → RAM Plus → 12GB additional → Total: 24GB
> This must be set before loading any AI model in ChatterUI.

---

## Phase 3 — App Configuration

*Completed: March 26, 2026*

**Status: ✅ COMPLETE**

### RT7 SD Card Mount Path

> **The SD card mounts at `/storage/69C4-815C/`, not `/sdcard/`.** This is a card-specific volume ID assigned by Android 15. Every path reference in this phase uses this mount point. If you're building your own device, find your card's mount point with `adb shell ls /storage/`.

### Step 1 — APK Installation

**Android 15 blocks `adb shell pm install` from external storage paths.** The standard approach of running `adb install /sdcard/APKs/app.apk` returns "No such file or directory" because `/sdcard/` points to internal storage, and even with the correct path, Android 15 blocks installs from external storage.

**Workaround:** Pull APKs from the card to the Mac, then install from the Mac:

```
adb pull /storage/69C4-815C/APKs/ ~/Desktop/BunkerAI_APKs/ && \
adb install -r ~/Desktop/BunkerAI_APKs/amaze.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/VLC-Android-3.6.2-arm64-v8a.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/kiwix-3.10.0.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/OsmAnd-android-full-arm64.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/chatterui.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/meshtastic.apk && \
adb install -r ~/Desktop/BunkerAI_APKs/briar.apk
```

**All 7 APKs installed successfully:**

| App | Package Name | Status |
| --- | --- | --- |
| Amaze File Manager | `com.amaze.filemanager` | ✅ |
| VLC | `org.videolan.vlc` | ✅ |
| Kiwix | `org.kiwix.kiwixmobile` | ✅ |
| OsmAnd | `net.osmand.plus` | ✅ |
| ChatterUI | `com.Vali98.ChatterUI` | ✅ |
| Meshtastic | `com.geeksville.mesh` | ✅ |
| Briar | `org.briarproject.briar.android` | ✅ |

> Note: Lawnchair (`app.lawnchair`) was already installed from Phase 0f. Fossify Gallery was added during Step 5 (see below).

### Step 2 — OsmAnd + Alaska Map

OsmAnd must be launched once to initialize its data directory before map data can be loaded.

1. Open OsmAnd on device → let it initialize → close
2. Set OsmAnd storage to SD card: `/storage/69C4-815C/android/data/net.osmand.plus/files/`
3. Extract Alaska OBF directly into OsmAnd's data directory:

```
adb shell unzip /storage/69C4-815C/APKs/Us_alaska_northamerica_2.obf.zip \
  -d /storage/69C4-815C/android/data/net.osmand.plus/files/
```

4. Reopen OsmAnd → navigate to Fairbanks → **offline rendering confirmed**

### Step 3 — ChatterUI + Phi-3 Benchmark

ChatterUI v0.8.8 is the AI inference interface. It loads GGUF model files directly from the SD card using llama.cpp under the hood. No internet required, no telemetry, fully open source.

**Configuration sequence:**

1. Open ChatterUI → hamburger menu → App Mode → confirm **Local** (default)
2. Hamburger menu → Models → tap **+** icon
3. Navigate to `/storage/69C4-815C/AI_Models/`
4. Select `Phi-3-mini-4k-instruct-q4.gguf` → choose **Use external model** (keeps GGUF on SD card, doesn't waste internal storage)
5. Long-press model name → open settings → configure:

| Parameter | Value | Rationale |
| --- | --- | --- |
| Context length | 4096 | Phi-3-mini-4k max; stay at max for medical queries |
| Threads | 6 | Leave 2 cores for OS; sweet spot for Dimensity 720 |
| Batch size | 512 | Good balance for Dimensity SoC |
| Generated tokens | 512 | Balances response completeness vs. speed |

6. Hamburger menu → Sampler → set Generated tokens to **512**
7. Enable **Context shift** and **Auto-load**

**Benchmark — Laceration Protocol Query:**

> "A person has a deep laceration on the left forearm, approximately 4cm long, bleeding moderately. No tendons visible. Remote location, no evacuation for 6 hours. What are the step-by-step field treatment actions?"

**Benchmark progression:**

| Config | Tokens | Threads | Time | Result |
| --- | --- | --- | --- | --- |
| Initial | 256 | 6 | 85s | Truncated at step 7 — incomplete |
| Expanded | 1024 | 6 | 134s | Complete 10-step response — too slow |
| Optimized | 512 | 4 | 103s | Complete — still over target |
| **Final** | **512** | **6** | **86s** | **✅ Complete response, under 90s target** |

**Final locked configuration:**

| Metric | Value |
| --- | --- |
| Model | Phi-3-mini-4k-instruct-q4.gguf |
| Generated tokens | 512 |
| Threads | 6 |
| Batch | 512 |
| Context | 4096 |
| Context shift | ON |
| Auto-load | ON |
| Benchmark time | **86 seconds** |

### Step 4 — Kiwix ZIM Library

**Pre-configuration cleanup:** `.meta4` files from the download process were cluttering the ZIM directory. Removed before adding to Kiwix:

```
adb shell rm /storage/69C4-815C/Kiwix/*.meta4
```

**Kiwix configuration:**

1. Open Kiwix → Settings → Storage → set to SD card (`/storage/69C4-815C/Kiwix/`)
2. Add content → navigate to `/storage/69C4-815C/Kiwix/`
3. Add each ZIM individually — Kiwix 3.x does not bulk-scan a folder

**Kiwix behavior note:** Kiwix on Android searches *within* individual opened ZIMs, not across the full library simultaneously. Open the relevant ZIM first (e.g., Wikipedia Medicine for medical queries), then search within it. This is by design and does not affect the build's workflow — Kiwix serves as a manual reference library separate from the AI reasoning layer.

### Step 5 — Lawnchair Dashboard

**Grid configuration:**

1. Long-press homescreen → Customize
2. Desktop grid → set to **6x6** (RT7 screen renders as 5 usable rows due to aspect ratio)

**Wallpaper — Black Background:**

The Oukitel RT7's native WallpaperPicker component is broken — it crashes on launch from both Settings and Lawnchair's wallpaper picker. The "My Photos" option in wallpaper settings also crashes consistently.

**Workaround:** Install Fossify Gallery and use its internal wallpaper engine:

```
# Download Fossify Gallery APK directly from GitHub releases API
curl -s "https://api.github.com/repos/FossifyOrg/Gallery/releases/latest" \
  | grep "browser_download_url" | grep ".apk" | head -1 | cut -d'"' -f4 \
  | xargs curl -L -o ~/Desktop/fossify-gallery.apk

# Install
adb install -r ~/Desktop/fossify-gallery.apk

# Push black wallpaper image
adb push ~/Desktop/black_wallpaper.png /sdcard/Pictures/black_wallpaper.png
```

Open Fossify Gallery → navigate to the black image → long-press → Set as wallpaper. This calls the Android wallpaper API directly, bypassing the broken system picker.

**Dashboard layout (as built):**

| Row | Content |
| --- | --- |
| Top | GPS widget + Battery indicator |
| Row 2 | ChatterUI (large tile — primary AI interface) |
| Row 3 | Kiwix / OsmAnd / Meshtastic |
| Row 4 | Briar / First Aid IFRC / Seek |
| Row 5 | Compass / IR Camera / Amaze |

### Step 6 — Remaining Apps

**Meshtastic:**
- Installed and opened
- Analytics → OFF
- Theme → Dark
- LoRa region configuration → pending Heltec V3 node arrival

**Briar:**
- Local identity created (no server required)
- Bluetooth pairing → pending second device test

**VLC:**
- Hardware acceleration → Automatic
- Play videos in background → ON
- Subtitles → OFF

**Amaze File Manager:**
- Installed — SD card bookmark configuration pending

---

## Phase 4 — Validation

*Status: 🔄 PARTIAL*

### Completed Validations

| Layer | Test | Result |
| --- | --- | --- |
| AI | Airplane Mode → ChatterUI → laceration query | ✅ 86 seconds — under 90s target |
| Knowledge | Kiwix → search within Wikipedia ZIM | ✅ Resolves offline |
| Navigation | OsmAnd → Alaska map → Fairbanks rendering → offline routing | ✅ Works fully offline |

### Pending Validations

| Layer | Test | Status |
| --- | --- | --- |
| Topo Maps | Open a GeoPDF from USGS_Topos/ | ⏳ Topos not yet downloaded |
| Species ID | Seek → point at plant → offline ID | ⏳ Pending |
| Comms (LoRa) | Meshtastic → pair with Heltec V3 → send + receive in Airplane Mode | ⏳ Pending hardware |
| Comms (P2P) | Briar → pair with second device → send + receive in Airplane Mode | ⏳ Pending second device |
| Solar | FlexSolar 36W → battery % increase at 50% brightness | ⏳ Pending outdoor test |

---

## Phase 5 — Final Lockdown

*Status: ⏳ PENDING*

> **⚠️ RECORD YOUR PIN BEFORE ENABLING KIOSK MODE. Test all apps one final time before locking.**

### Lockdown Sequence

1. Enable App Pinning: Settings → Security → App Pinning → Enable
2. Lock Lawnchair layout: Lawnchair Settings → Home Screen → Lock Home Screen → ON
3. Hide non-mission apps via Lawnchair: Settings → General → Hidden Apps
4. Disable connectivity: Wi-Fi off, Mobile Data off, NFC off → Airplane Mode as default state (Bluetooth enabled only for Meshtastic/Briar when in use)
5. Set Screen Timeout to maximum
6. Disable Lock Screen Notifications
7. Disable USB Debugging: Settings → Developer Options → USB Debugging → **OFF**
8. Hide Developer Options — run before unplugging Mac:

```
adb shell settings put global development_settings_enabled 0
```

**Result:** Device powers on directly to Lawnchair survival dashboard. No Google prompts, no notifications, no app store. Purpose-built offline survival intelligence terminal.

---

## Pending Items

| Item | Notes |
| --- | --- |
| USGS GeoPDF Topos | Download from ngmdb.usgs.gov/topoview — Fairbanks D-1 through D-4, Livengood, Circle, Big Delta, Healy, Yukon Flats, Chena River drainage. Alaska quads are 1:63,000 scale |
| Seek by iNaturalist | Download offline NA species database (~2GB), verify offline ID |
| First Aid IFRC | Download and install — APKPure source |
| Meshtastic Node Pairing | Pair with Heltec V3 915MHz node — configure channel, verify Airplane Mode message |
| Briar P2P Test | Pair with second device via Bluetooth, verify message in Airplane Mode |
| Solar Panel Test | Outdoors test at 50% brightness with FlexSolar 36W — record charge rate |
| Amaze Configuration | Set SD card bookmarks for quick field navigation |
| Phase 4 Validation | Complete remaining validation tests (topo maps, species ID, comms, solar) |
| Phase 5 Lockdown | Execute final lockdown sequence after all validations pass |

---

*BunkerAI-RT7 Alaska Edition — Full Build Log*
*Zero-Dark-Access | Open Architecture | Alaska-Hardened | Validated Redundancy*
*Interior Alaska AO — Fairbanks / Fort Wainwright / Chena River drainage*