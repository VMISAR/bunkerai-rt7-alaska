# BunkerAI-RT7 Alaska Edition — Full Build Log

*Oukitel RT7 Titan 5G | SanDisk Extreme 512GB | Interior Alaska*

---

## Build Overview

**Mission:** Build a fully self-contained, air-gapped survival intelligence terminal on the Oukitel RT7 Titan 5G that exceeds the commercial BunkerAI "BOB" tablet in every operationally relevant category — battery life, ruggedness, AI capability, and open architecture — at roughly half the cost.

**Design constraints that govern every decision:**

- **Zero-Dark-Access:** No internet connection required for any function. No towers, no cloud, no cellular.
- **Single Interface:** All tools accessible from one unified launcher. One purpose, one screen.
- **Open Architecture:** No locked models, no proprietary apps, no vendor dependency.
- **Alaska-Hardened:** Specs, content, maps, and use cases tuned for Interior Alaska — extreme cold, long winter nights, remote terrain, grid-down scenarios.

**Setup machine:** MacBook Air (macOS)
**Transfer method:** ADB (Android Debug Bridge) over USB-C

---

## Phase 0 — First Boot Protocol

*Completed: March 16, 2026*

### Hardware State at Start

| Item | Detail |
|---|---|
| Device | Oukitel RT7 Titan 5G |
| Serial | RT7TITANA1506745 |
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
|---|---|---|
| Language | English | Standard |
| Wi-Fi | Skipped — no network connected | Prevent background sync on first boot |
| Google Account | Skipped | Prevent account binding and cloud backup |
| Google Services | All declined | Eliminate telemetry at OS level |
| PIN | Set | Required for ADB auth and kiosk lockdown |
| Oukitel screens | All skipped | No manufacturer cloud services needed |

### ADB Setup on MacBook Air

```bash
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

```bash
# Verify connection
adb devices
# Expected: RT7TITANA1506745   device
# If "unauthorized": check RT7 screen for Allow popup
```

### Pre-Build Package Snapshot

Before any changes, export the complete package list as the permanent before-state record:

```bash
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
|---|---|
| `com.android.nfc` | **Causes boot loop on MT6853 EEA** |
| `com.google.android.gms` | Briar, Seek, others reference GMS at runtime |
| `com.android.camera2` | IR night vision — core build capability |
| `com.android.settings` | System becomes unconfigurable |
| `com.android.bluetooth` | Required for Briar + Meshtastic |
| `android.hardware.location.*` | Navigation foundation |

### Lesson

The Nova Launcher kiosk configuration (Phase 5) achieves the same clean interface without touching the system partition. It locks the device to approved apps, hides everything else, and removes the interface clutter. The debloat adds nothing the kiosk mode doesn't also deliver — but it can brick the device.

**Do not debloat the RT7 Titan.**

---

## Phase 0c — Firmware Recovery

*Completed: March 17, 2026*

### The Problem

Device in boot loop. Factory reset failed (userdata wipe can't fix system partition corruption). Bootloader locked. No root access. No Windows PC available. Nine recovery attempts exhausted before finding a path forward.

### Recovery Attempts — Full Log

#### Attempt 1 — Factory Reset via Recovery Mode
`adb reboot recovery` → Wipe data / Factory reset → Reboot
**Result: FAILED.** Factory reset only wipes userdata. Corruption is in `super.img`. Device returned to corrupt screen.

#### Attempt 2 — BROM Mode Entry (Multiple Methods)
BROM (Boot ROM) is the lowest-level MediaTek recovery mode — bypasses the bootloader entirely.

Methods tried: Volume Down + plug USB, Volume Up + plug USB, Volume Up + Volume Down + plug USB, plug first then Volume Down, all held 10–15 seconds.

**Result: FAILED.** BROM mode on this device likely requires precise timing or a physical PCB test point short. Cannot be forced externally without disassembly.

*Note: mtkclient `devices` returned a Wiko Lenny 4 entry — this was a cached entry in mtkclient's local database, not a live device. The RT7 was never detected by mtkclient.*

#### Attempt 3 — Fastboot Flash (Full Partition Set)
`adb reboot bootloader` → `fastboot flash vbmeta vbmeta.img`
**Result: FAILED.** `Writing 'vbmeta_a' FAILED (remote: 'not allowed in locked state')` — bootloader locked.

#### Attempt 4 — Fastboot OEM Unlock
`fastboot flashing unlock`
First attempt: `FAILED (remote: 'Unlock operation is not allowed')`
Second attempt: `OKAY [9.208s]` — appeared to succeed.
Follow-up: `fastboot getvar unlocked` → `unlocked: no`

**Result: FAILED.** The unlock command was accepted but didn't persist. `oem_unlock_enabled` was never set to 1 in Developer Options before the device stopped booting. The bootloader requires this flag set from within the OS before it honors the fastboot unlock command.

#### Attempt 5 — ADB Settings Command to Enable OEM Unlock
```bash
adb shell settings put global oem_unlock_enabled 1
adb shell settings get global oem_unlock_enabled
```
**Result: FAILED.** Command ran without error but didn't persist after reboot. Android was not fully booted when ADB connected — settings database not in a writable state.

#### Attempt 6 — Legacy Fastboot OEM Unlock Command
`fastboot oem unlock`
**Result: FAILED.** `FAILED (remote: 'unknown command')` — this bootloader doesn't support the legacy syntax.

#### Attempt 7 — Flash boot.img Only (Locked Bootloader)
`fastboot flash boot boot.img`
**Result: FAILED.** `FAILED (remote: 'not allowed in locked state')` — no partition is exempt from locked state restriction on this bootloader.

#### Attempt 8 — ADB Root / DD Write to Block Devices
All partitions visible via `adb shell ls /dev/block/by-name/` (super, boot_a, boot_b, vbmeta_a, etc.)
```bash
adb root      # "adbd cannot run as root in production builds"
adb shell su  # "su: inaccessible or not found"
```
**Result: FAILED.** Production build, no su binary. ADB runs as `uid=2000(shell)`. Block device writes require root.

#### Attempt 9 — Recovery Mode ADB Root
`adb reboot recovery` → attempt `adb root` from recovery
**Result: Inconclusive.** Timed out before commands could be executed — recovery menu auto-dismissed. Recovery mode ADB root was not confirmed or denied.

### Resolution

**Option taken: B — BROM Mode via PCB Test Point**

Entry into BROM (Boot ROM) mode was achieved by shorting a physical test point on the RT7 motherboard — requiring partial disassembly. Once BROM mode was confirmed, SP Flash Tool was used to flash the full firmware image including `super.img`, restoring the system partition to a clean baseline.

> This is the only confirmed recovery path for a locked-bootloader RT7 Titan with a corrupted `super.img`. All software-only methods (Attempts 1–9) failed. Physical PCB access was required.

**Available firmware files used:**

| File | Version | Date |
|---|---|---|
| TP758_OQ_P07_NFC_6853_TO_EEA_V1.4.8_S251017.zip | V1.4.8 | Oct 2025 |

Firmware path on Mac: `/Users/Jason/MEGA downloads/RT7 TITAN 5G A13 带NFC/TP758_OQ_P07_NFC_6853_T0_EEA_V1.4.8_S251017/`

Key files confirmed present in ZIP:
- `MT6853_Android_scatter.txt` — partition map
- `super.img` — 5.1GB — contains the Android OS
- `preloader_tp758_oq_p07_nfc_6853_t0_eea.bin`
- All partition images (boot, vbmeta, dtbo, gz, lk, etc.)

### Post-Recovery Device State

| Item | Status |
|---|---|
| Firmware | V1.4.8 clean baseline |
| Android | 15 — fresh install |
| USB Debugging | Re-enabled |
| ADB Connection | Working — MacBook Air confirmed |
| Build String | OUKITEL_RT7_TITAN_5G_EEA_A15_V07_20250910 (or newer post-flash) |

> The build proceeds without any debloat. The Nova Launcher kiosk mode handles the interface lockdown cleanly without touching system packages.

---

## Phase 0d — Debloat Phase 1 (UAD-NG)

*Completed: March 23, 2026*

**Status: ✅ COMPLETE — Silent State achieved**

> This phase replaced the failed manual ADB debloat attempt (Phase 0b). UAD-NG's risk-rated GUI and per-package description database eliminated the guesswork that caused the previous boot loop.

### Objective

Achieve a "Silent State" — remove all non-essential manufacturer bloatware, Google telemetry, and persistent background services — without touching boot-critical system packages. Primary goals: maximize 32,000mAh battery life and ensure full 24GB RAM availability for offline AI models.

### Tooling Stack

| Tool | Role |
|---|---|
| UAD-NG (Universal Android Debloater — Next Generation) | Risk-rated GUI — categorizes packages as Recommended / Advanced / Expert / Unsafe |
| Terminal (Zsh) | CLI override for packages outside UAD-NG database |
| ADB (Android Debug Bridge) | Device communication layer |
| Nova Launcher v8.0.18 | System Anchor — see Section 6 below |

### Procedure A — Initial GUI Pass (UAD-NG)

UAD-NG was launched via Terminal to ensure it inherited the ADB environment:
```bash
universal-android-debloater
```

Pre-flight package export before any removal:
```bash
adb shell pm list packages -f > ~/Desktop/RT7_Factory_Baseline.txt
```

**Selection criteria:** Packages marked "Recommended" or "Advanced" that did not impact core hardware (GPS, IR Camera, Bluetooth, NFC). Oukitel-specific packages lacked community definitions in the UAD-NG database for Android 15 — these required manual CLI override.

**MediaTek safety rule:** For any `com.mediatek.*` or `com.wtk.*` package, the UAD-NG description field was checked before action. Any package whose description referenced "Boot," "Init," "NVRAM," or "Modem" was immediately whitelisted. This is the direct lesson from the Phase 0b boot loop.

### Procedure B — Dumpsys Identification Drill

To identify stubborn or hidden manufacturer apps appearing on the home screen, the following command was run while the target app was in focus:
```bash
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'
```

This returned the exact package name (e.g., `com.ddu.ai`) for surgical removal.

### Procedure C — Deep Freeze Persistence Kill-Chain

Standard `pm uninstall --user 0` commands failed on several Oukitel packages due to "Watcher" services in the firmware that trigger re-installs on reboot. The following five-step sequence was developed to break the self-repair loop permanently:
```bash
adb shell am force-stop [package.name]       # 1. Force Stop
adb shell pm clear [package.name]            # 2. Clear Data
adb shell pm disable-user --user 0 [package.name]  # 3. Disable
adb shell pm hide [package.name]             # 4. Mask/Hide
adb shell pm uninstall --user 0 [package.name]     # 5. Uninstall
```

### Package Disposition Registry

| App Name | Package ID | Method | Result |
|---|---|---|---|
| Google Kids Space | `com.google.android.apps.kids.home` | UAD-NG Uninstall | Purged |
| OKGame Center | `com.oukitel.gamecenter` | Deep Freeze Kill-Chain | Purged |
| Oukitel AI | `com.ddu.ai` | Deep Freeze Kill-Chain | Purged |
| Oukitel Market | `com.ddu.appstore` | Deep Freeze Kill-Chain | Purged |
| Oukitel Weather | `com.ddu.android.weather` | Deep Freeze Kill-Chain | Purged |
| Customer Center | `com.easycontrol.customercenter` | Mask/Hide | Hidden |
| Tappic | `com.hebs.tappic` | UAD-NG Uninstall | Purged |

### Critical Whitelist — DO NOT REMOVE

| Package | Reason Retained |
|---|---|
| `com.mediatek.ygps` | Satellite acquisition — essential for Interior Alaska GPS |
| `com.mediatek.camera` | IR Night Vision sensor driver |
| `com.google.android.permissioncontroller` | Required for offline app permission grants |
| `com.wtk.factory` | Hardware calibration and sensor management |

### System Anchor

Because the stock Oukitel launcher triggers self-repair of bloatware icons, Nova Launcher was side-loaded and set as Default Home. This stabilized the UI and ensured the Deep Freeze commands remained effective across reboots.

> **Note:** Nova Launcher's role as System Anchor was later superseded. See Phase 0f — Launcher Swap.

### Emergency Restoration Procedure

If any removed package causes hardware instability, restore without factory reset:

UAD-NG: Change status filter from "Installed" to "Uninstalled" → select package → click Restore.

CLI backup method:
```bash
adb shell pm install-existing [package.name]
```

---

## Phase 0f — Launcher Swap (Nova → Lawnchair)

*Completed: March 25, 2026*

**Status: ✅ COMPLETE**

### Decision

Nova Launcher was replaced with Lawnchair 15 Beta 2.1. Nova served as a functional System Anchor during debloat (Phase 0d) but was disqualified as the permanent launcher for the following reasons:

- Active development ceased September 2025 following acquisition and team layoff
- Ads introduced into the free app drawer
- "Do Not Sell My Data" privacy opt-out confirmed non-functional in the paid Prime version
- Violates the BunkerAI zero-telemetry posture

Lawnchair is open source (AOSP Launcher3 base), actively maintained, carries no telemetry, and provides all required features (gestures, app hiding, drawer groups) at no cost.

### APK Verification

| Field | Value |
|---|---|
| Version | 15 Beta 2.1 |
| Release Date | March 1, 2026 |
| Source | https://github.com/LawnchairLauncher/lawnchair/releases |
| SHA256 | `64a52605c299a7af9eeaafbf04a13c6e617f91c5930c8c160a3e23ab0579a6e6` |
| Verified on Mac | `shasum -a 256 lawnchair.apk` — confirmed match |
| Install method | ADB sideload — no Play Store dependency |
| Package name | `app.lawnchair` |

### Installation Procedure
```bash
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
|---|---|---|---|---|
| Drive 1 | UNTITLED | ExFAT | 159GB | ~149GB |
| Drive 2 | Bunker | ExFAT | 112GB | ~80GB |

### UNTITLED Drive — Content

**Root:** `/Volumes/UNTITLED/BunkerAI/`

#### Core Reference ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
|---|---|---|
| `wikipedia_en_all_maxi_2025-08.zim` | 111GB | Full English Wikipedia with images. Transfer first, verify before anything else. |
| `wikibooks_en_all_maxi_2026-01.zim` | 5.1GB | Repair manuals, field guides, technical how-tos |
| `wikiversity_en_all_maxi_2026-02.zim` | 2.2GB | Structured courses — science, engineering, skills |
| `wikivoyage_en_all_maxi_2026-03.zim` | 1.0GB | Geography, routes, regional reference |

#### Medical ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
|---|---|---|
| `wikipedia_en_medicine_maxi_2026-01.zim` | 2.0GB | Full medical Wikipedia with images |
| `medlineplus.gov_en_all_2025-01.zim` | 1.8GB | NIH — symptoms, drugs, treatments (non-clinician language) |
| `fas-military-medicine_en_2025-06.zim` | 78MB | Military field medicine — austere environment trauma care |
| `nhs.uk_en_medicines_2025-12.zim` | 16MB | NHS drug reference — dosing, interactions, contraindications |
| `wwwnc.cdc.gov_en_all_2024-11.zim` | 170MB | CDC disease and public health reference |

#### Military & Survival ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
|---|---|---|
| `armypubs_en_all_2024-12.zim` | 7.7GB | Complete Army field manuals and doctrine |
| `outdoors.stackexchange.com_en_all_2026-02.zim` | 136MB | Wilderness survival, cold weather ops, Interior Alaska conditions |
| `solar.lowtechmagazine.com_mul_all_2025-01.zim` | 668MB | Low-tech practical solutions — water, power, food preservation |

#### Repair & Construction ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
|---|---|---|
| `ifixit_en_all_2025-12.zim` | 3.3GB | Step-by-step repair guides with photos |
| `diy.stackexchange.com_en_all_2026-02.zim` | 1.9GB | Home repair, construction, building |
| `mechanics.stackexchange.com_en_all_2026-02.zim` | 323MB | Vehicle repair, engines, maintenance |
| `woodworking.stackexchange.com_en_all_2026-02.zim` | 100MB | Joinery, construction from raw timber |

#### Communications & Electronics ZIM Files → `/Volumes/UNTITLED/BunkerAI/ZIM/`

| File | Size | Notes |
|---|---|---|
| `ham.stackexchange.com_en_all_2026-02.zim` | 72MB | Ham radio, antennas, emergency comms — supports Meshtastic layer |
| `electronics.stackexchange.com_en_all_2026-02.zim` | 3.9GB | Circuits, components, building from scratch |
| `physics.stackexchange.com_en_all_2026-02.zim` | 1.7GB | Foundational science for engineering applications |

#### AI Model Files → `/Volumes/UNTITLED/BunkerAI/Models/`

| File | Size | Notes |
|---|---|---|
| `Phi-3-mini-4k-instruct-q4.gguf` | 2.2GB | Primary model — 3.8B params, Q4 quantization, MIT licensed |
| `Phi-3.5-mini-instruct-Q4_K_M.gguf` | 2.2GB | Secondary model — improved reasoning, same footprint |

Source: Microsoft / Bartowski on HuggingFace.

```bash
# Download Phi-3.5 Mini via HuggingFace CLI
huggingface-cli download bartowski/Phi-3.5-mini-instruct-GGUF \
  --include "Phi-3.5-mini-instruct-Q4_K_M.gguf" --local-dir ~/BunkerAI/Models/
```

#### Maps & Navigation → `/Volumes/UNTITLED/BunkerAI/Maps/`

| File | Size | Notes |
|---|---|---|
| `OsmAnd-android-full-arm64.apk` | 196MB | ARM64 build — required for RT7's Dimensity 720 |
| `Us_alaska_northamerica_2.obf.zip` | 232MB | Complete Alaska OpenStreetMap — roads, trails, POIs, waterways |

#### ADFG Alaska Reference PDFs → `/Volumes/UNTITLED/BunkerAI/ADFG/`

| File | Size | Notes |
|---|---|---|
| `alaska_hunting_regs_2025-2026.pdf` | 9.0MB | Complete Alaska hunting regulations — 144 pages |
| `GMU20_interior_alaska_2025-2026.pdf` | 1.0MB | Game Management Unit 20 — Fairbanks / Interior Alaska AO |
| `subsistence_fishing_regs_2025-2026.pdf` | 1.1MB | Statewide subsistence fishing regulations |
| `subsistence_hunt_supplement_2025-2026.pdf` | 1.1MB | Tier I, II, Community Harvest permits — Interior Alaska |

---

### Bunker Drive — Content

**Root:** `/Volumes/Bunker/BunkerAI/`

#### Project Gutenberg LCC Volumes → `/Volumes/Bunker/BunkerAI/ZIM/gutenberg/`

Rather than downloading the 206GB English monolith, downloaded by Library of Congress Classification subject code. Each is a standalone ZIM file.

> **Why Gutenberg matters for survival:** A 19th century farming almanac assumes you have no tractor. An 1890 medical textbook assumes you have no hospital. An 1870 construction manual assumes you have hand tools and timber. This is exactly the knowledge profile needed for long-term grid-down operations — it was written for the scenario.

| File | Size | Subject |
|---|---|---|
| `gutenberg_en_lcc-q_2026-03.zim` | 17GB | Science — biology, botany, zoology, natural history, geology |
| `gutenberg_en_lcc-t_2026-03.zim` | 12GB | Technology — engineering, construction, forge work, masonry |
| `gutenberg_en_lcc-a_2026-03.zim` | 9.1GB | General Works — encyclopedias, almanacs, reference collections |
| `gutenberg_en_lcc-g_2026-03.zim` | 7.5GB | Geography — exploration, wilderness travel, indigenous land use |
| `gutenberg_en_lcc-s_2026-03.zim` | 4.2GB | Agriculture — farming, animal husbandry, food preservation, forestry |
| `gutenberg_en_lcc-r_2026-03.zim` | 1.9GB | Medicine — pre-modern medical texts, herbal medicine, wound management |
| `gutenberg_en_lcc-u_2026-03.zim` | 1.2GB | Military Science — field craft, fortification, logistics, tactics |

#### CD3WD Pre-Industrial Knowledge ISOs → `/Volumes/Bunker/BunkerAI/CD3WD/`

Six DVD ISO files (~26GB total). CD3WD = CD3 World Development — compiled to help developing-world communities achieve basic infrastructure without imported technology.

> **Why CD3WD is different from everything else in this build:** Every other reference assumes you have something from the modern world — a vehicle, a drug, a replacement part. CD3WD assumes you have raw materials, hand tools, and time.

Content includes: hand-dug wells and gravity-fed water systems, pit sawing and timber framing, soap and candle making, grain processing and fermentation, food preservation without refrigeration, basic blacksmithing, hide tanning, rope from plant fiber, brick and mortar from local materials.

| File | Size |
|---|---|
| `1001_cd3wd.iso` | 4.3GB |
| `1002_cd3wd.iso` | 4.3GB |
| `1003_cd3wd.iso` | 4.3GB |
| `1004_cd3wd.iso` | 4.3GB |
| `1005_cd3wd.iso` | 4.3GB |
| `1006_cd3wd.iso` | 4.4GB |

> **Format note:** CD3WD files are ISO disk images, not ZIM files. They don't open in Kiwix. Use the Amaze File Manager APK (included in the build) to browse ISO contents directly, or extract before transfer: `hdiutil mount 1001_cd3wd.iso` on Mac.

#### Additional Stack Exchange ZIM Files → `/Volumes/Bunker/BunkerAI/ZIM/stackExchange/`

| File | Size | Notes |
|---|---|---|
| `cooking.stackexchange.com_en_all_2026-02.zim` | 226MB | Food prep, preservation, ingredient substitutions |
| `gardening.stackexchange.com_en_all_2026-02.zim` | 882MB | Vegetable cultivation, soil management — Interior Alaska conditions |
| `sustainability.stackexchange.com_en_all_2026-02.zim` | 26MB | Off-grid systems, long-term self-sufficiency |
| `biology.stackexchange.com_en_all_2026-02.zim` | 403MB | Plant/animal ID, ecology, physiology |
| `engineering.stackexchange.com_en_all_2026-02.zim` | 242MB | Mechanical, civil, electrical, structural Q&A |

#### APK Files → `/Volumes/Bunker/BunkerAI/APKs/`

| File | Size | Notes |
|---|---|---|
| `kiwix-3.10.0.apk` | 94MB | Kiwix Reader — must be installed before any ZIM is accessible |
| `VLC-Android-3.6.2-arm64-v8a.apk` | 45MB | VLC — ARM64 build for RT7 processor |

---

### Content Summary

| Category | Size |
|---|---|
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

*Status: IN PROGRESS — awaiting SanDisk Extreme 512GB arrival*

### Prerequisites

- SanDisk Extreme 512GB (V30/U3) — inserted and formatted exFAT via RT7 Settings → Storage → Format SD Card
- Anker PowerLine III Flow USB-C connected Mac ↔ RT7
- RT7 powered on, notification shade → USB → File Transfer mode
- ADB installed: `brew install android-platform-tools`
- ADB verified: `adb devices` — must show `device` not `unauthorized`
- **Virtual RAM enabled BEFORE loading any AI model:** Settings → RAM → RAM Plus → 12GB additional (total 24GB)
- Mac sleep disabled: run `caffeinate -i` in a Terminal window during long transfers

### Create MicroSD Folder Structure First

```bash
adb shell mkdir -p /sdcard/Kiwix
adb shell mkdir -p /sdcard/AI_Models
adb shell mkdir -p /sdcard/BunkerAI/ADFG
adb shell mkdir -p /sdcard/BunkerAI/CD3WD
adb shell mkdir -p /sdcard/USGS_Topos/Interior_Alaska
adb shell mkdir -p /sdcard/OsmAnd
```

### Transfer Order and Commands

Transfer in this order — smallest and most critical first, Wikipedia last.

```bash
# 1. AI Models (~4.4GB) — most critical, smallest
adb push /Volumes/UNTITLED/BunkerAI/Models/ /sdcard/AI_Models/

# 2. ADFG PDFs (~12MB) — fast, operationally irreplaceable
adb push /Volumes/UNTITLED/BunkerAI/ADFG/ /sdcard/BunkerAI/ADFG/

# 3. OsmAnd APK
adb install /Volumes/UNTITLED/BunkerAI/Maps/OsmAnd-android-full-arm64.apk

# 4. OsmAnd Map Data
adb push /Volumes/UNTITLED/BunkerAI/Maps/Us_alaska_northamerica_2.obf.zip \
  /sdcard/Android/data/net.osmand/files/

# 5. Kiwix APK
adb install /Volumes/Bunker/BunkerAI/APKs/kiwix-3.10.0.apk

# 6. VLC APK
adb install /Volumes/Bunker/BunkerAI/APKs/VLC-Android-3.6.2-arm64-v8a.apk

# 7. Stack Exchange ZIMs (UNTITLED — all except Wikipedia)
adb push /Volumes/UNTITLED/BunkerAI/ZIM/ /sdcard/Kiwix/
# Note: this pushes all ZIMs in the folder; do NOT include wikipedia yet

# 8. Gutenberg LCC ZIMs
adb push /Volumes/Bunker/BunkerAI/ZIM/gutenberg/ /sdcard/Kiwix/

# 9. Additional Stack Exchange (Bunker)
adb push /Volumes/Bunker/BunkerAI/ZIM/stackExchange/ /sdcard/Kiwix/

# 10. CD3WD ISOs
adb push /Volumes/Bunker/BunkerAI/CD3WD/ /sdcard/BunkerAI/CD3WD/

# 11. Wikipedia (111GB) — START BEFORE BED, verify in the morning
adb push /Volumes/UNTITLED/BunkerAI/ZIM/wikipedia_en_all_maxi_2025-08.zim /sdcard/Kiwix/
```

---

## Phase 3 — App Configuration

*Status: PENDING*

### Enable Virtual RAM First

> Do this before any app configuration that involves loading AI models.

Settings → RAM → RAM Plus → set to **12GB additional**
Total becomes 24GB. Required before loading any model file.

### App Install List

| App | Install Method | Priority |
|---|---|---|
| Kiwix Reader | `adb install kiwix-3.10.0.apk` | 1 — Required before ZIMs work |
| OsmAnd | `adb install OsmAnd-android-full-arm64.apk` | 2 |
| VLC Media Player | `adb install VLC-Android-3.6.2-arm64-v8a.apk` | 3 |
| Layla (AI Interface) | APKPure → `adb install` | 4 — Primary AI interface |
| Lawnchair Launcher | GitHub → `adb install lawnchair.apk` | 5 — Dashboard (installed in Phase 0f) |
| Meshtastic | meshtastic.org → `adb install` | 6 |
| Briar | briarproject.org → `adb install` | 7 |
| Seek by iNaturalist | APKPure → `adb install` | 8 |
| First Aid by IFRC | APKPure → `adb install` | 9 |
| Amaze File Manager | GitHub → `adb install` | 10 — Required for CD3WD ISO browsing |
| Whisper Voice Input | APKPure → search "offline speech recognition" | 11 |

### Layla — AI Configuration

1. Install Layla APK via ADB
2. Open Layla → Load Model → navigate to `/sdcard/AI_Models/`
3. Select: `Phi-3-mini-4k-instruct-q4.gguf` (PRIMARY)
4. Run inference speed test:
   > *Query: "I have a deep laceration on my forearm, a basic first aid kit, and no medical evacuation for 48 hours. What are my options for wound closure and infection prevention?"*
5. **Target: under 90 seconds for a full response**
6. Record token speed for build log
7. If too slow or incomplete: switch to `Phi-3.5-mini-instruct-Q4_K_M.gguf` and retest

### Kiwix — Knowledge Base Configuration

1. Open Kiwix → Settings → Storage Location → point to SD card
2. Add Library → navigate to `/sdcard/Kiwix/`
3. Add each ZIM file individually — index builds automatically (Wikipedia may take several minutes)
4. Test searches:
   - "hypothermia treatment" in Wikipedia
   - "how to start a fire" in WikiHow (once loaded)

### Lawnchair — Dashboard Configuration

> Nova Launcher was replaced with Lawnchair 15 Beta 2.1 in Phase 0f. All dashboard configuration below applies to Lawnchair. See LAUNCHER_LAWNCHAIR.md for full configuration reference.

**Theme:** Black background (#000000), icon labels in amber (#FFA500) or green (#00FF41)

| Screen Zone | Widget / App | Function |
|---|---|---|
| Top Bar | GPS Coordinates Widget | Live lat/long — no tap required |
| Top Bar | Battery % Indicator | Power status at a glance |
| Center (Large) | Layla | Primary AI interface — largest tile |
| Left Column | Kiwix Reader | Knowledge base |
| Left Column | OsmAnd | Navigation |
| Left Column | Meshtastic | LoRa field comms |
| Right Column | Briar | Close-range encrypted comms |
| Right Column | First Aid IFRC | Medical reference |
| Bottom Row | Seek by iNaturalist | Plant/fungi/fauna ID |
| Bottom Row | Compass Widget | Hardware compass |
| Bottom Row | IR Camera Shortcut | Night vision access |

### Meshtastic — LoRa Configuration

1. Install Meshtastic APK
2. Pair with Heltec V3 915MHz node via Bluetooth
3. Configure channel name and frequency (915MHz US band)
4. Test: send and receive message with second node in Airplane Mode

### Briar — P2P Communications

1. Install Briar APK
2. Create local account (no server required)
3. Pair with second Briar device via Bluetooth
4. Test: send and receive in Airplane Mode

### Seek — Species Identification

1. Install Seek APK
2. Settings → enable Offline Mode
3. Download North American species database (~2GB)
4. Test: point camera at any plant, confirm offline ID works

> **Foraging safety note:** Seek identifies species but does not always flag Alaska-specific toxicity. Always cross-reference any foraged plant against the ADFG Edible and Poisonous Plants PDF before consuming. Seek is an identification tool, not a safety guarantee.

---

## Phase 4 — Validation

*Status: PENDING*

All six layers must pass before final lockdown. Do not lock the device until all tests complete.

### Validation Tests

| Layer | Test | Pass Criteria |
|---|---|---|
| AI | Airplane Mode → Layla → laceration query | Full response under 90 seconds |
| Knowledge | Kiwix search: "hypothermia treatment" (Wikipedia) + "how to start a fire" (WikiHow) | Both resolve offline |
| Navigation | OsmAnd loads Alaska map → pin near Fairbanks → routing verified | Works fully offline |
| Topo Maps | Open a GeoPDF from `/sdcard/USGS_Topos/` | Contour lines and place names legible |
| Species ID | Seek → point at any plant | Offline identification confirmed |
| Comms (LoRa) | Meshtastic → pair with Heltec V3 → send + receive in Airplane Mode | LoRa (not Bluetooth) message confirmed |
| Comms (P2P) | Briar → pair with second device → send + receive in Airplane Mode | Message sent and received |
| Solar | FlexSolar 36W panel outdoors → battery % increases at 50% brightness | Net-positive charge confirmed; record rate and conditions |

### Inference Speed Benchmark

Record these after Phi-3 Mini load:

| Metric | Target | Actual |
|---|---|---|
| Time to first token | < 15 seconds | |
| Full response — laceration query | < 90 seconds | |
| Token speed (tok/sec) | TBD | |

---

## Phase 5 — Final Lockdown

*Status: PENDING*

> **⚠️ RECORD YOUR PIN BEFORE ENABLING KIOSK MODE. Test all apps one final time before locking. Once kiosk mode is active, navigation is restricted to approved apps only.**

### Lockdown Sequence

1. Enable App Pinning: Settings → Security → App Pinning → Enable
2. Configure Lawnchair as kiosk-equivalent: Lawnchair → Settings → Home Screen → Lock Home Screen layout. Use Android App Pinning (enabled in Step 1) to restrict navigation to approved apps.3. Disable non-essential system apps: Play Store, Chrome, Gmail — installed but inaccessible
4. Disable connectivity: Wi-Fi off, Mobile Data off, NFC off → Airplane Mode as default state (Bluetooth enabled only for Meshtastic/Briar when in use)
5. Set Screen Timeout to maximum
6. Disable Lock Screen Notifications
7. Disable USB Debugging: Settings → Developer Options → USB Debugging → **OFF**
8. Hide Developer Options — run before unplugging Mac:

```bash
adb shell settings put global development_settings_enabled 0
```

**Result:** Device powers on directly to Nova Launcher survival dashboard. No Google prompts, no notifications, no app store. Purpose-built offline survival intelligence terminal.

---

## Pending Items — Next Session

| Item | Notes |
|---|---|
| USGS GeoPDF Topos | Download from ngmdb.usgs.gov/topoview — Fairbanks D-1 through D-4, Livengood, Circle, Big Delta, Healy, Yukon Flats, Chena River drainage. Alaska quads are 1:63,000 scale — NOT 1:24,000 |
| MDWiki ZIM | library.kiwix.org — ~2GB |
| Merck Manual ZIM | library.kiwix.org — ~1GB |
| WikiHow ZIM | library.kiwix.org — ~10GB |
| CD3WD ISO Extraction | Consider extracting ISOs on Mac before transfer: `hdiutil mount 1001_cd3wd.iso` — makes content browsable without ISO mounter app |
| Gutenberg full EN | 206GB — requires batch method: download → transfer → clear staging → repeat. 232GB headroom available. |
| Meshtastic Node Pairing | Pair with Heltec V3 915MHz node — configure channel, verify Airplane Mode message |
| Solar Panel Test | Outdoors test at 50% brightness with FlexSolar 36W — record charge rate |
| Lawnchair Dashboard | Build survival dashboard layout per Phase 3 — see LAUNCHER_LAWNCHAIR.md || Phi-3 Inference Speed Test | After model load — laceration query benchmark |

---

*BunkerAI-RT7 Alaska Edition — Full Build Log*
*Zero-Dark-Access | Open Architecture | Alaska-Hardened | Validated Redundancy*
*Interior Alaska AO — Fairbanks / Fort Wainwright / Chena River drainage*
