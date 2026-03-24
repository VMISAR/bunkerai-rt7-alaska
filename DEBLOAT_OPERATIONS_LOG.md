# RT7 Titan 5G: Debloat Operations Log
**Project:** BunkerAI / Survival Tablet  
**Phase 1:** Baseline & Hardening  
**Status:** COMPLETE  
**Last Updated:** March 23, 2026

---

## 1. Objective
To achieve a "Silent State" on the Oukitel RT7 Titan 5G by removing all non-essential manufacturer bloatware, Google telemetry, and persistent background services. The primary goal is to maximize the 32,000mAh battery life and ensure the 24GB of RAM is fully available for offline AI models and navigation.

## 2. Tooling Stack
* **Host:** MacBook Air (macOS)
* **Interface:** USB-C to ADB (Android Debug Bridge)
* **Software:** * `UAD-NG` (Universal Android Debloater - Next Generation)
    * `Terminal` (Zsh)
    * `Nova Launcher v8.0.18` (System Anchor)

---

## 3. Operational Procedures

### A. Initial GUI Pass (UAD-NG)
The first layer of debloating was performed using the UAD-NG GUI to identify and batch-uninstall common Google and AOSP bloat.
* **Selection Criteria:** Packages marked "Recommended" or "Advanced" that did not impact core hardware (GPS/IR Camera).
* **Limitation:** Oukitel-specific packages lacked community definitions in the UAD-NG database for Android 15, requiring manual override via CLI.

### B. The "Dumpsys" Identification Drill
To identify stubborn or hidden manufacturer apps appearing on the homescreen, the following command was used while the target app was in focus:
```bash
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'
```
*This provided the exact package name (e.g., `com.ddu.ai`) for surgical removal.*

### C. The "Deep Freeze" Persistence Kill-Chain
Standard uninstalls often failed due to "Watcher" services in the Oukitel firmware that trigger re-installs upon reboot. The following sequence was developed to "Mask" and "Disable" packages, effectively breaking the self-repair loop:

1. **Force Stop:** `adb shell am force-stop [package.name]`
2. **Clear Data:** `adb shell pm clear [package.name]`
3. **Disable:** `adb shell pm disable-user --user 0 [package.name]`
4. **Mask/Hide:** `adb shell pm hide [package.name]`
5. **Uninstall:** `adb shell pm uninstall --user 0 [package.name]`

---

## 4. Package Disposition Registry

| App Name | Package ID | Action | Result |
| :--- | :--- | :--- | :--- |
| **Google Kids Space** | `com.google.android.apps.kids.home` | Uninstall | Purged |
| **OKGame Center** | `com.oukitel.gamecenter` | Kill-Chain | Purged |
| **Oukitel AI** | `com.ddu.ai` | Kill-Chain | Purged |
| **Oukitel Market** | `com.ddu.appstore` | Kill-Chain | Purged |
| **Oukitel Weather** | `com.ddu.android.weather` | Kill-Chain | Purged |
| **Customer Center** | `com.easycontrol.customercenter` | Mask/Hide | Hidden |
| **Tappic** | `com.hebs.tappic` | Uninstall | Purged |

---

## 5. Critical Whitelist (DO NOT REMOVE)
The following packages were intentionally retained to preserve the RT7's mission-critical hardware functionality:
* **`com.mediatek.ygps`**: Essential for satellite acquisition in Interior Alaska.
* **`com.mediatek.camera`**: Required for the IR Night Vision sensor.
* **`com.google.android.permissioncontroller`**: Essential for granting offline app permissions.
* **`com.wtk.factory`**: Hardware calibration and sensor management.

## 6. System Anchor: Nova Launcher
Because the stock Oukitel launcher triggers "self-repair" of bloatware icons, **Nova Launcher** was side-loaded and set as **Default Home**. This stabilized the UI and allowed the "Deep Freeze" commands to remain effective across reboots.
