# Debloat Issues — BunkerAI-RT7 Alaska Edition

**Status: UNSOLVED — Active Open Problem**

The RT7 Titan debloat has not been successfully completed. This document records exactly what was attempted, what broke it, how recovery was achieved, and what the next attempt plan looks like. Anyone attempting to debloat an Oukitel RT7 Titan (MT6853 / Android 15 EEA) should read this first.

---

## Summary

A full ADB debloat was attempted across three batches. Batches 1 and 2 completed cleanly. Batch 3 caused a boot loop — the device got stuck on the Oukitel splash screen and could not complete a normal boot. Recovery was achieved via Android factory wipe. The firmware reflash via Windows + SP Flash Tool is still pending.

**The debloat is not required for this build.** Nova Launcher kiosk mode achieves the same clean interface without touching system packages. The debloat remains an open goal for reducing background telemetry and freeing RAM.

---

## What Was Confirmed Safe — Batches 1 and 2

These packages were successfully removed via `adb shell pm uninstall --user 0` with no adverse effects. The device booted cleanly after each batch.

### Batch 1 — Third Party & Telemetry

```bash
adb shell pm uninstall --user 0 com.ddu.ai
adb shell pm uninstall --user 0 com.ddu.browser.oversea
adb shell pm uninstall --user 0 com.ddu.android.weather
adb shell pm uninstall --user 0 com.ddu.appstore
adb shell pm uninstall --user 0 com.hebs.tappic
adb shell pm uninstall --user 0 com.chamsion.livewallpaper
adb shell pm uninstall --user 0 com.easycontrol.customercenter
adb shell pm uninstall --user 0 com.google.android.adservices.api
adb shell pm uninstall --user 0 com.google.mainline.adservices
adb shell pm uninstall --user 0 com.google.mainline.telemetry
adb shell pm uninstall --user 0 com.google.android.ondevicepersonalization.services
adb shell pm uninstall --user 0 com.google.android.federatedcompute
adb shell pm uninstall --user 0 com.google.android.gms.location.history
adb shell pm uninstall --user 0 com.google.android.gms.supervision
```

### Batch 2 — Unused Google Apps & Services

```bash
adb shell pm uninstall --user 0 com.google.android.apps.bard
adb shell pm uninstall --user 0 com.google.android.calendar
adb shell pm uninstall --user 0 com.google.android.apps.wellbeing
adb shell pm uninstall --user 0 com.google.android.projection.gearhead
adb shell pm uninstall --user 0 com.google.android.apps.kids.home
adb shell pm uninstall --user 0 com.google.android.apps.youtube.kids
adb shell pm uninstall --user 0 com.google.android.apps.youtube.music
adb shell pm uninstall --user 0 com.google.android.apps.turbo
adb shell pm uninstall --user 0 com.google.android.healthconnect.controller
adb shell pm uninstall --user 0 com.google.android.health.connect.backuprestore
adb shell pm uninstall --user 0 com.google.android.apps.adm
adb shell pm uninstall --user 0 com.google.android.apps.safetyhub
adb shell pm uninstall --user 0 com.google.android.apps.restore
adb shell pm uninstall --user 0 com.google.android.setupwizard
adb shell pm uninstall --user 0 com.google.android.apps.setupwizard.searchselector
adb shell pm uninstall --user 0 com.google.android.onetimeinitializer
adb shell pm uninstall --user 0 com.google.android.partnersetup
adb shell pm uninstall --user 0 com.oukitel.update
adb shell pm uninstall --user 0 com.oukitel.gamecenter
```

Also safe (from category-based removal):

```bash
adb shell pm uninstall --user 0 com.android.chrome
adb shell pm uninstall --user 0 com.google.android.gm
adb shell pm uninstall --user 0 com.google.android.apps.maps
adb shell pm uninstall --user 0 com.google.android.youtube
adb shell pm uninstall --user 0 com.google.android.apps.docs
adb shell pm uninstall --user 0 com.google.android.apps.photos
adb shell pm uninstall --user 0 com.google.android.apps.tachyon
adb shell pm uninstall --user 0 com.google.android.videos
adb shell pm uninstall --user 0 com.google.android.apps.books
adb shell pm uninstall --user 0 com.google.android.play.games
adb shell pm uninstall --user 0 com.google.android.music
adb shell pm uninstall --user 0 com.google.android.apps.magazines
adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red
adb shell pm uninstall --user 0 com.google.android.marvin.talkback
adb shell pm uninstall --user 0 com.google.ar.core
adb shell pm uninstall --user 0 com.google.android.feedback
adb shell pm uninstall --user 0 com.google.android.keep
adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox
adb shell pm uninstall --user 0 com.google.android.apps.googleassistant
adb shell pm uninstall --user 0 com.google.android.hotword
```

---

## What Broke It — Batch 3

Batch 3 targeted factory tools and system extras. After these commands ran, the device booted to the Oukitel splash screen and never progressed further.

```bash
# THESE COMMANDS CAUSED THE BOOT LOOP — DO NOT RUN WITHOUT FURTHER TESTING
adb shell pm uninstall --user 0 com.mediatek.engineermode
adb shell pm uninstall --user 0 com.mediatek.callrecorder
adb shell pm uninstall --user 0 com.mediatek.omacp
adb shell pm uninstall --user 0 com.mediatek.mdmlsample
adb shell pm uninstall --user 0 com.mediatek.mdmconfig
adb shell pm uninstall --user 0 com.wtk.stresstest
adb shell pm uninstall --user 0 com.wtk.factory
adb shell pm uninstall --user 0 com.debug.loggerui
adb shell pm uninstall --user 0 com.android.egg
adb shell pm uninstall --user 0 com.android.fmradio
adb shell pm uninstall --user 0 com.android.traceur
adb shell pm uninstall --user 0 com.android.devicediagnostics
adb shell pm uninstall --user 0 com.android.avatarpicker
adb shell pm uninstall --user 0 com.android.musicfx
adb shell pm uninstall --user 0 com.android.partnerbrowsercustomizations.example
```

**Most likely culprits** based on the crash pattern — one or more of these is a boot dependency on the MT6853 EEA build:

| Package | Suspected Risk |
|---|---|
| `com.mediatek.engineermode` | MediaTek factory diagnostics — may be init dependency |
| `com.mediatek.mdmconfig` | Mobile device management config — may be init dependency |
| `com.wtk.factory` | WTK factory test app — unknown boot dependency risk |
| `com.debug.loggerui` | Debug logging — may be tied to kernel services |

> **Community question:** If you have an RT7 Titan or another MT6853 device and you know which of these is actually safe to remove, open an issue. The goal is to isolate the one package causing the problem so the rest of Batch 3 can be cleaned up.

---

## Recovery — What Actually Worked

### What Failed First

With the device stuck on the Oukitel splash screen, ADB was still active but Android services hadn't started. Every restore command returned `can't find service: package`. Multiple recovery attempts failed:

- Hard reboot → still stuck
- `adb shell pm install-existing [package]` → `can't find service: package`
- `adb reboot recovery` → "No Command" screen, ADB dropped
- Physical volume buttons unresponsive during boot
- `adb shell recovery --wipe_data` → no devices found (ADB dropped in recovery)
- `adb reboot bootloader` → attempted but bootloader locked
- `for` loop hammering restore commands → all failed, services never started

### What Finally Worked

**`adb reboot recovery` → Power + Volume Up in recovery → Wipe data / Factory reset**

1. `adb reboot recovery` sent the device into recovery mode
2. On the "No Command" / Android robot screen: held **Power + Volume Up simultaneously for 3 seconds**, then released both
3. Recovery menu appeared with full options
4. Selected **Wipe data / Factory reset** using volume buttons to navigate, power to confirm
5. Device wiped and rebooted to clean Android 15 baseline

**Total time lost:** ~4 hours

**What the factory wipe did NOT fix:** If the `--user 0` uninstall had corrupted the system partition rather than just the user profile, a factory wipe would not have helped. In this case the `--user 0` method worked as intended — packages were only hidden from the user profile, not deleted — so the wipe restored the user profile to factory defaults and all hidden packages became visible again.

---

## Current Device State

| Item | Status |
|---|---|
| Android | 15 — clean factory wipe baseline |
| Debloat | Not completed — all packages restored by wipe |
| Firmware reflash | **PENDING** — Windows + SP Flash Tool (son's laptop) |
| ADB connection | Working — MacBook Air confirmed |

---

## Plan for Next Attempt

### Option A — Firmware Reflash First (Recommended)

Flash a clean V1.4.8 factory image via Windows + SP Flash Tool before attempting any debloat. This gives a confirmed clean baseline and eliminates any uncertainty about the current device state.

Firmware: `TP758_OQ_PO7_NFC_6853_TO_EEA_V1.4.8_S251017.zip`
Tool: SP Flash Tool (Windows)
Required files: `MT6853_Android_scatter.txt` + all partition images

> **Note:** This is still pending as of March 2026. Requires a Windows machine — a MacBook Air cannot run SP Flash Tool natively.

### Option B — Incremental Batch 3 Testing

After firmware reflash, test Batch 3 packages one at a time with a reboot verification after each removal. This isolates the specific culprit rather than guessing.

```bash
# Test one package at a time — reboot after each
adb shell pm uninstall --user 0 com.android.egg
# Reboot, verify clean boot, then continue to next
adb shell pm uninstall --user 0 com.android.fmradio
# Reboot, verify...
# Continue one by one through Batch 3 list
```

This takes longer but produces a confirmed-safe package list for the community.

---

## Packages Confirmed NOT Safe to Remove

| Package | Consequence |
|---|---|
| Unknown (Batch 3) | Boot loop — one or more packages in Batch 3 is a boot dependency |
| `com.google.android.gms` | Required by Briar, Seek, and other build apps at runtime |
| `com.android.camera2` | IR night vision — core build capability |
| `com.android.settings` | System becomes unconfigurable |
| `com.android.bluetooth` | Required for Meshtastic + Briar |
| `android.hardware.location.*` | Navigation foundation |
| `com.android.emergency` | Never remove on any device |

---

## Open Community Questions

If you have an RT7 Titan or MT6853 device and can answer any of these, open an issue:

1. Which specific Batch 3 package causes the boot loop on MT6853 / Android 15 EEA?
2. Is `com.mediatek.engineermode` safe to remove via `--user 0` on this chipset?
3. Is `com.wtk.factory` or `com.wtk.stresstest` tied to any boot init service?
4. Has anyone completed a full debloat on an Oukitel RT7 Titan without causing a boot loop?
5. Does the boot loop occur on Android 13 / V1.2.9 firmware, or only on Android 15 / V1.4.8?

---

*BunkerAI-RT7 Alaska Edition — Debloat Issues Reference*
*Last updated: March 2026 | Status: Open*
