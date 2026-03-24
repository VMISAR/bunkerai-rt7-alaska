# Debloat Reference — BunkerAI-RT7 Alaska Edition

**Status: PHASE 1 COMPLETE — Further passes pending**
**Last Updated: March 23, 2026**

---

## Summary

Manual ADB debloat (Batch 3) caused a boot loop on March 16–17. After factory wipe recovery, a second attempt using **UAD-NG (Universal Android Debloater - Next Generation)** succeeded. Phase 1 debloat is complete. The device is in a stabilized "Silent State" with Nova Launcher set as the system anchor.

---

## Why the First Attempt Failed

Manual `adb shell pm uninstall --user 0` on Batch 3 packages caused a boot loop because there was no safety layer — no way to know which MediaTek/Oukitel packages were boot dependencies before removing them.

UAD-NG solved this by categorizing every package by risk level before you touch anything.

---

## The Tool That Works: UAD-NG

**Universal Android Debloater - Next Generation** is a GUI tool that wraps ADB with a community-maintained package database. Every package has a risk category and description before you remove it.

### Install on macOS

```bash
brew install universal-android-debloater
```

### Launch (must be via Terminal to inherit ADB environment)

```bash
universal-android-debloater
```

### Risk Categories

| Category | Safety | What Lives Here |
|---|---|---|
| Recommended | ✅ 100% safe | Google tracking, marketing apps, redundant tools |
| Advanced | ✅ Generally safe | Secondary features, Oukitel widgets |
| Expert | ⚠️ High risk | MediaTek system services |
| Unsafe | 🚫 Boot-loop triggers | UAD-NG hides these by default |

**Rule for MediaTek packages:** Set filter to Expert → search `mediatek` → read the description. If it mentions "Boot," "Init," "NVRAM," or "Modem" → Add to Whitelist immediately.

---

## Phase 1 Results — Completed March 23, 2026

### Method Used

- Initial pass: UAD-NG GUI — Recommended and Advanced categories
- Stubborn packages: "Deep Freeze" kill-chain (see below)
- UI stabilization: Nova Launcher set as Default Home

### Package Disposition

| App Name | Package ID | Method | Result |
|---|---|---|---|
| Google Kids Space | `com.google.android.apps.kids.home` | UAD-NG Uninstall | Purged |
| OKGame Center | `com.oukitel.gamecenter` | Deep Freeze | Purged |
| Oukitel AI | `com.ddu.ai` | Deep Freeze | Purged |
| Oukitel Market | `com.ddu.appstore` | Deep Freeze | Purged |
| Oukitel Weather | `com.ddu.android.weather` | Deep Freeze | Purged |
| Customer Center | `com.easycontrol.customercenter` | Mask/Hide | Hidden |
| Tappic | `com.hebs.tappic` | UAD-NG Uninstall | Purged |

---

## The Deep Freeze Kill-Chain

Standard `pm uninstall --user 0` fails on certain Oukitel packages because the firmware includes "Watcher" services that re-install removed packages on reboot. This 5-step sequence breaks the self-repair loop:

```bash
# Run in order for each stubborn package
adb shell am force-stop [package.name]
adb shell pm clear [package.name]
adb shell pm disable-user --user 0 [package.name]
adb shell pm hide [package.name]
adb shell pm uninstall --user 0 [package.name]
```

### Finding a Package Name While the App Is On Screen

```bash
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'
```

This returns the exact package name of whatever app is currently in focus — useful for identifying unlabeled Oukitel preloads.

---

## Critical Whitelist — DO NOT REMOVE

| Package | Function | Why It Stays |
|---|---|---|
| `com.mediatek.ygps` | GPS satellite acquisition | Essential for Interior Alaska navigation |
| `com.mediatek.camera` | IR Night Vision sensor | Core build capability |
| `com.google.android.permissioncontroller` | App permission grants | Required for offline app permissions |
| `com.wtk.factory` | Hardware calibration and sensor management | Confirmed safe to retain — see note below |

> **Correction from previous version:** `com.wtk.factory` was previously listed as a possible boot-loop culprit. It is confirmed safe and must remain on the whitelist. The actual boot-loop cause during the manual ADB attempt is still unidentified — it was one or more other Batch 3 packages.

---

## Nova Launcher as System Anchor

The stock Oukitel launcher triggers re-installation of bloatware icons even after successful removal. Setting Nova Launcher as Default Home stabilizes the UI and allows Deep Freeze removals to persist across reboots.

**Set Nova as Default Home:**
Settings → Apps → Default Apps → Home App → Nova Launcher

Once set, bloatware icons no longer reappear after reboot even if the underlying package is only hidden rather than fully purged.

---

## Emergency Package Restoration

If a hardware feature stops working after a removal:

**Via UAD-NG GUI:**
1. Change status filter from "Installed" to "Uninstalled"
2. Find the package
3. Click Restore

**Via Terminal:**
```bash
adb shell pm install-existing [package.name]
```

---

## Phase 2 Debloat — Pending

Phase 1 targeted Recommended and Advanced categories. Phase 2 will address Expert-level MediaTek packages using UAD-NG's description field as a safety check before each removal. This pass will not be attempted until after the firmware reflash via SP Flash Tool.

**Firmware reflash status:** Pending — requires Windows PC

---

## Previous Manual ADB Attempt — Historical Record

For the full account of the manual ADB boot loop incident (March 16–17, 2026), nine recovery attempts, and factory wipe resolution, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

**Key lesson:** Never run manual ADB debloat on MediaTek/Oukitel packages without a tool like UAD-NG that provides safety categorization first.

---

*BunkerAI-RT7 Alaska Edition — Debloat Reference*
*Last updated: March 23, 2026 | Phase 1 Status: Complete*
