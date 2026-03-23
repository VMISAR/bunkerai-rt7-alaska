# Troubleshooting — BunkerAI-RT7 Alaska Edition

---

## The Boot Loop Incident

**Date:** March 16–17, 2026
**Cause:** ADB debloat — one or more packages in Batch 3 is a boot dependency on MT6853 / Android 15 EEA
**Result:** Boot loop — device stuck on Oukitel splash screen indefinitely
**Recovery:** Android factory wipe via recovery mode (Power + Volume Up)
**Current state:** Clean Android 15 factory baseline — debloat not yet re-attempted

> Full debloat history, confirmed-safe package lists, and next attempt plan: see [DEBLOAT_ISSUES.md](DEBLOAT_ISSUES.md)

---

## What Happened

Batches 1 and 2 of the debloat completed cleanly. After Batch 3 ran, the device booted to the Oukitel splash screen and never progressed. Android services never started — ADB showed a connection but every package restore command returned `can't find service: package`.

The factory wipe was the only thing that worked.

---

## Recovery — Step by Step

If your RT7 Titan is stuck in a boot loop after debloat, this is the path that worked:

**Step 1 — Attempt ADB restore first (while stuck on splash screen)**

ADB may still be active even though Android has not booted. Connect via USB-C and try:

```bash
adb devices
# If it shows "device" — services may be running
adb shell pm install-existing com.mediatek.engineermode
adb shell pm install-existing com.mediatek.mdmconfig
adb shell pm install-existing com.wtk.factory
adb shell pm install-existing com.debug.loggerui
```

If you get `can't find service: package` — Android services have not started and restore commands will not work. Move to Step 2.

**Step 2 — Force into recovery mode via ADB**

```bash
adb reboot recovery
```

The device will reboot to a black screen with an Android robot icon and the words "No Command."

**Step 3 — Unlock the recovery menu**

On the "No Command" screen:
- Hold **Power + Volume Up simultaneously** for 3 seconds
- Release both at the same time
- The full recovery menu will appear

**Step 4 — Factory wipe**

- Navigate to **Wipe data / Factory reset** using Volume Down
- Press Power to select
- Confirm when prompted
- Device wipes and reboots automatically — takes 2–3 minutes

**Result:** Clean Android 15 factory baseline. All hidden packages restored. All user data erased.

---

## What the Factory Wipe Does and Does Not Fix

**Does fix:**
- Boot loop caused by `--user 0` package hiding
- Any corrupted user profile state
- Restores all packages hidden via `pm uninstall --user 0`

**Does NOT fix:**
- Corruption in the system partition (`super.img`)
- Boot issues caused by root-level modifications
- Problems that persist after a clean wipe

If the factory wipe does not resolve the boot loop, the system partition may be corrupted. That requires a full firmware reflash — see below.

---

## Firmware Reflash — PENDING

**Status: Not yet performed as of March 2026**

A full firmware reflash via Windows + SP Flash Tool is planned as the next step before re-attempting debloat. This will flash a clean V1.4.8 factory image directly to the device partitions, bypassing all software-level recovery paths.

**Why reflash before the next debloat attempt:**
- Eliminates any uncertainty about current device state
- Gives a verified clean baseline to test from
- SP Flash Tool works regardless of bootloader lock state

**Requirements:**
- Windows PC (SP Flash Tool does not run on macOS natively)
- SP Flash Tool — spflashtool.com
- Firmware ZIP: `TP758_OQ_PO7_NFC_6853_TO_EEA_V1.4.8_S251017.zip`
- Must contain: `MT6853_Android_scatter.txt` + `preloader_*.bin` + all partition `.img` files

**Basic SP Flash Tool process:**
1. Open SP Flash Tool on Windows
2. Load `MT6853_Android_scatter.txt` (scatter file)
3. Select **Download Only** mode
4. Power off RT7 completely
5. Click Download in SP Flash Tool
6. Connect RT7 via USB-C while powered off
7. SP Flash Tool detects device and begins flash automatically
8. Green circle = success. Device reboots to clean factory state.

> SP Flash Tool flashes at the partition level — it bypasses the Android bootloader entirely. Bootloader lock state does not affect this process.

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

---

*BunkerAI-RT7 Alaska Edition — Troubleshooting Reference*
*Last updated: March 2026*
