# Troubleshooting — BunkerAI-RT7 Alaska Edition

---

## The Boot Loop Incident

**Date:** March 16–17, 2026
**Cause:** ADB debloat — one or more packages in Batch 3 is a boot dependency on MT6853 / Android 15 EEA
**Result:** Boot loop — device stuck on Oukitel splash screen indefinitely
**Recovery:** BROM mode via PCB test point + mtkclient on M1 MacBook Air + SP Flash Tool firmware reflash
**Current state:** Clean Android 15 factory baseline — UAD-NG debloat completed successfully in Phase 0d

> Full debloat history, confirmed-safe package lists, and next attempt plan: see [DEBLOAT_ISSUES.md](https://github.com/VMISAR/bunkerai-rt7-alaska/blob/main/DEBLOAT_ISSUES.md)

---

## What Happened

Batches 1 and 2 of the debloat completed cleanly. After Batch 3 ran, the device booted to the Oukitel splash screen and never progressed. Android services never started — ADB showed a connection but every package restore command returned `can't find service: package`.

Factory reset (userdata wipe) did not fix it because the corruption was in the `super.img` system partition, not userdata. Nine software-only recovery attempts failed before a hardware-level solution was found.

---

## Recovery — Step by Step

If your RT7 Titan is stuck in a boot loop after debloat, try these steps in order. Steps 1–3 are quick and non-destructive. Step 4 is the nuclear option.

### Step 1 — Attempt ADB restore first (while stuck on splash screen)

ADB may still be active even though Android has not booted. Connect via USB-C and try:

```
adb devices
# If it shows "device" — services may be running
adb shell pm install-existing com.mediatek.engineermode
adb shell pm install-existing com.mediatek.mdmconfig
adb shell pm install-existing com.wtk.factory
adb shell pm install-existing com.debug.loggerui
```

If you get `can't find service: package` — Android services have not started and restore commands will not work. Move to Step 2.

### Step 2 — Force into recovery mode via ADB

```
adb reboot recovery
```

The device will reboot to a black screen with an Android robot icon and the words "No Command."

### Step 3 — Factory wipe via recovery menu

On the "No Command" screen:

* Hold **Power + Volume Up simultaneously** for 3 seconds
* Release both at the same time
* The full recovery menu will appear
* Navigate to **Wipe data / Factory reset** using Volume Down
* Press Power to select
* Confirm when prompted
* Device wipes and reboots automatically — takes 2–3 minutes

**If this fixes it:** You're back to a clean Android 15 baseline. All user data erased, all hidden packages restored. Proceed to Phase 0d (UAD-NG debloat) for a safer approach.

**If this does NOT fix it:** The corruption is in the system partition (`super.img`). Proceed to Step 4.

### Step 4 — BROM Mode via PCB Test Point (Nuclear Option)

> **This is the only confirmed recovery path for a locked-bootloader RT7 Titan with a corrupted `super.img`.** All software-only BROM entry methods (Volume button combinations while plugging USB) failed on this device. Physical PCB access is required.

**Requirements:**

* Partial disassembly of the RT7 to access the motherboard
* mtkclient installed on Mac (`pip install mtkclient`)
* SP Flash Tool (Windows) or mtkclient's built-in flash capability (Mac/Linux)
* Firmware ZIP: `TP758_OQ_PO7_NFC_6853_TO_EEA_V1.4.8_S251017.zip`
* Must contain: `MT6853_Android_scatter.txt` + `preloader_*.bin` + all partition `.img` files (including `super.img` at 5.1GB)

**Procedure:**

1. Power off RT7 completely
2. Disassemble to access motherboard — locate BROM test point
3. Short the test point while connecting USB-C to Mac
4. mtkclient detects device in BROM mode
5. Flash full firmware image using scatter file
6. Device reboots to clean factory state

**This was confirmed working on an M1 MacBook Air running mtkclient.** No Windows machine was required for the BROM entry and flash — mtkclient handles the full sequence natively on macOS.

---

## What the Factory Wipe Does and Does Not Fix

**Does fix:**

* Boot loop caused by `--user 0` package hiding (if the issue is in userdata, not system)
* Any corrupted user profile state
* Restores all packages hidden via `pm uninstall --user 0`

**Does NOT fix:**

* Corruption in the system partition (`super.img`)
* Boot issues caused by root-level modifications
* Problems that persist after a clean wipe — these require BROM-level reflash (Step 4)

---

## RT7 Firmware Quirks

These are non-standard behaviors confirmed on the Oukitel RT7 Titan running Android 15 EEA:

| Quirk | Detail | Workaround |
| --- | --- | --- |
| SD card mount path | Mounts at `/storage/69C4-815C/`, not `/sdcard/` | Use `adb shell ls /storage/` to find your card's ID |
| ADB install from external storage | Android 15 blocks `adb shell pm install` from external storage paths | `adb pull` APK to Mac, then `adb install -r` from Mac |
| WallpaperPicker | Broken — crashes on launch from Settings and Lawnchair | Install Fossify Gallery, set wallpaper from within Gallery app |
| Lawnchair grid | RT7 screen limits grid to 5 usable rows despite 6x6 setting | Design dashboard layout for 5 rows |
| Software BROM entry | All software-only Volume button methods fail | Physical PCB test point short required |
| Oukitel Watcher services | Some manufacturer apps auto-reinstall after `pm uninstall --user 0` | Use Deep Freeze Kill-Chain (5-step sequence — see Phase 0d) |

---

## Other Known Issues

### ADB Connection Drops in Recovery Mode

Recovery mode on the RT7 does not maintain an ADB connection by default. After `adb reboot recovery`, the device shows "No Command" and `adb devices` returns nothing. This is normal — use the physical button combination (Power + Volume Up) to unlock the recovery menu.

### Volume Buttons Unresponsive During Normal Boot

Volume buttons may not respond while the device is stuck on the splash screen. They do respond in recovery mode once the recovery menu is visible.

### `--user 0` Packages Not Restoring

If `adb shell pm install-existing [package]` returns `can't find service: package`, the Package Manager service has not started. Restore commands will not work in this state — proceed directly to recovery mode.

### `adb shell recovery --wipe_data` Returns No Devices

This command may fail if ADB drops when recovery mode loads. If this happens, use the physical Power + Volume Up method in Step 3 above.

### Kiwix Search Scope

Kiwix on Android searches within individual opened ZIMs, not across the full library. If a search returns no results, make sure you have the correct ZIM opened first (e.g., open Wikipedia Medicine ZIM before searching for drug interactions).

---

*BunkerAI-RT7 Alaska Edition — Troubleshooting Reference*
*Last updated: April 2026*