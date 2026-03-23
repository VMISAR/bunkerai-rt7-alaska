# Troubleshooting — BunkerAI-RT7 Alaska Edition

---

## The Boot Loop Incident

**Date:** March 16–17, 2026
**Cause:** ADB debloat removed `com.android.nfc` on MediaTek MT6853 / Android 15 EEA build
**Result:** Boot loop — "Software corrupted — press power to boot" on every boot
**Resolution:** Full firmware reflash to V1.4.8

---

### Root Cause

On the Oukitel RT7 Titan 5G (MT6853 / Android 15 EEA), `com.android.nfc` is coupled to a hardware initialization service that runs before Android fully loads. Hiding it via `adb shell pm uninstall --user 0` causes the init sequence to fail permanently.

The corruption lands in the `super.img` system partition — not in userdata. A factory reset cannot fix it.

**Do not remove these packages on the RT7 Titan:**

| Package | Consequence |
|---|---|
| `com.android.nfc` | **Boot loop — cannot recover without reflash** |
| `com.android.stk` | Potentially unsafe — test before removing |
| `com.android.printspooler` | Potentially unsafe — test before removing |
| `com.android.dreams.*` | Potentially unsafe on this build |

---

### Recovery Options (If You Break It)

Listed in order of success probability:

**Option A — Windows PC + SP Flash Tool** *(highest success rate)*
SP Flash Tool is the standard MediaTek firmware flash utility. With the scatter file (`MT6853_Android_scatter.txt`) and all partition images from the firmware ZIP, it flashes the complete firmware in 10–15 minutes regardless of bootloader lock state. Requires any Windows machine temporarily.

**Option B — BROM Mode via PCB Test Point**
Physical disassembly to short the BROM test point on the MT6853 board forces BROM mode. Then mtkclient or SP Flash Tool on Mac can complete the flash. Requires electronics experience and the correct test point location for this board.

**Option C — Recovery Mode ADB Root**
If `adb root` works in recovery mode, root access allows direct `dd` writes to block devices from Mac, flashing the complete firmware without fastboot or BROM.

**Option D — Oukitel Support**
Contact support@oukitel.com with your serial number and build string. Request unlock token or factory flash service.

---

### Firmware Files

Three firmware ZIPs are available from the Oukitel website for the RT7 Titan with NFC:

| File | Version | Date |
|---|---|---|
| TP758_OQ_P07_NFC_6853_TO_EEA_V1.2.9_S231205.zip | V1.2.9 | Dec 2023 |
| TP758_OQ_P07_NFC_6853_TO_EEA_V1.4.1_S250414.zip | V1.4.1 | Apr 2025 |
| TP758_OQ_PO7_NFC_6853_TO_EEA_V1.4.8_S251017.zip | V1.4.8 | Oct 2025 |

**Use V1.4.8** — newest, cleanest baseline.

The ZIP must contain `MT6853_Android_scatter.txt` (partition map) and the `preloader_*.bin` file. Confirm these are present before attempting any flash.

---

### Why Debloat Is Not Needed

The Nova Launcher kiosk configuration achieves the same result — a locked-down single-purpose interface — without touching the system partition:

- All non-essential apps hidden from the interface
- Navigation restricted to approved apps only
- No Google prompts, no notifications, no app store visible
- Device boots directly to the survival dashboard

The debloat adds zero capability that the kiosk mode doesn't also deliver. It only adds risk.

---

### ADB Package Restore Reference

If you attempted debloat and need to restore packages before the device fully breaks:

```bash
# Restore any single package
adb shell pm install-existing com.package.name.here

# Common restores
adb shell pm install-existing com.android.nfc
adb shell pm install-existing com.android.printspooler
adb shell pm install-existing com.android.stk

# Find package names in your pre-debloat snapshot
# (rt7_packages.txt saved to Mac Desktop during setup)
```

This only works while ADB is still functional. Once the boot loop starts, the restore commands can no longer reach the package manager.

---

### Community Questions (Unresolved)

If you have answers to any of these, open an issue or PR:

1. Is recovery mode ADB on the RT7 Titan / MT6853 confirmed to run as root?
2. Is there a known BROM test point location for the MT6853 / TP758 board?
3. Does anyone have a DA (Download Agent) file for MT6853 that works with mtkclient on macOS?
4. Has anyone successfully reflashed an Oukitel RT7 Titan from macOS without Windows or BROM mode access?
5. Which specific system packages on the MT6853 EEA build are safe to remove via `--user 0`?

---

*BunkerAI-RT7 Alaska Edition — Troubleshooting Reference*
*Zero-Dark-Access | Open Architecture | Alaska-Hardened*
