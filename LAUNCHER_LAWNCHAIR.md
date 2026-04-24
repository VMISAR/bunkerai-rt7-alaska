# LAUNCHER_LAWNCHAIR.md
**Project:** BunkerAI-RT7 Alaska Edition
**Hardware:** Oukitel RT7 Titan 5G (Android 15)
**Launcher:** Lawnchair 15 Beta 2.1
**Status:** ✅ Installed — Configuration In Progress

---

## 1. Decision Record

### Why Nova Launcher Was Replaced

Nova Launcher served as the **System Anchor** during Phase 0d debloat operations — it was side-loaded to suppress the Oukitel stock launcher's bloatware self-repair behavior. It was functional for that purpose. It was not suitable as the permanent launcher for this build.

| Disqualifying Factor | Detail |
|---|---|
| Development abandoned | Original dev team laid off after acquisition; co-founder departed September 2025 |
| No future Android compatibility guaranteed | No active development means future OS updates may break it |
| Ads in free app drawer | Violates zero-distraction mission interface requirement |
| Privacy opt-out non-functional | "Do Not Sell My Data" setting confirmed broken in paid Prime version |
| Telemetry posture failure | A survival terminal with a deliberate air-gap posture cannot run a launcher with non-functional privacy controls |

### Why Lawnchair

| Requirement | Lawnchair Delivers |
|---|---|
| Open source | AOSP Launcher3 base — full source on GitHub |
| No telemetry | No data collection by design; confirmed in source |
| Active development | 15 Beta 2.1 released March 1, 2026 |
| Android 15 native | Built on Launcher3 from Android 15 — no compatibility shim |
| Full gesture support | Free — no paywall |
| App hiding | Free — no paywall |
| App drawer groups | Free — no paywall |
| No ads | None |
| No Play Store dependency | Sideloads cleanly via ADB |

---

## 2. APK Source and Verification

| Field | Value |
|---|---|
| **Version** | 15 Beta 2.1 |
| **Release Date** | March 1, 2026 |
| **Source** | https://github.com/LawnchairLauncher/lawnchair/releases |
| **Package Name** | `app.lawnchair` |
| **File Size** | ~16.47 MB |
| **SHA256** | `64a52605c299a7af9eeaafbf04a13c6e617f91c5930c8c160a3e23ab0579a6e6` |
| **Verified** | Yes — `shasum -a 256 lawnchair.apk` on Mac confirmed match prior to install |
| **Install Method** | ADB sideload — no Play Store dependency |

> **Always verify SHA256 before installing any APK.** Download only from the official GitHub releases page. Never use third-party APK mirror sites for this build.

### Verification Command

```bash
shasum -a 256 ~/Desktop/lawnchair.apk
```

Output must match the SHA256 above exactly — every character. If it does not match, discard the file and re-download.

---

## 3. Installation Procedure

### Prerequisites

- USB Debugging enabled on RT7: Settings → Developer Options → USB Debugging → **ON**
- Anker PowerLine III Flow USB-C connected Mac ↔ RT7
- Notification shade → USB → **File Transfer** mode selected
- ADB connection verified:

```bash
adb devices
# Expected: <device_serial>   device
# If "unauthorized": check RT7 screen for Allow popup
```

### Step 1 — Install Lawnchair alongside Nova

Nova is still the active launcher at this point. That is correct — do not remove it yet.

```bash
adb install ~/Desktop/lawnchair.apk
# Expected output: Performing Streamed Install → Success
```

### Step 2 — Switch Default Launcher (On-Device)

This step **must be performed on the tablet directly.** Android 15 requires user confirmation for default app changes and will not accept this command via ADB.

```
Settings → Apps → Default Apps → Home App → Lawnchair
```

The home screen switches to Lawnchair immediately. Nova is still installed but no longer active.

### Step 3 — Uninstall Nova

```bash
adb shell pm uninstall com.teslacoilsw.launcher
# Expected: Success
```

### Step 4 — Verify Clean State

```bash
# Confirm Lawnchair is present
adb shell pm list packages | grep lawnchair
# Expected: package:app.lawnchair

# Confirm Nova is gone
adb shell pm list packages | grep tesla
# Expected: no output
```

---

## 4. Key Settings Paths (Lawnchair)

Lawnchair settings paths differ from Nova. Use this table when configuring.

| Setting | Path |
|---|---|
| Grid size | Long-press home screen → Customize → Grid |
| Icon size | Long-press home screen → Customize → Icon Size |
| App drawer layout | Long-press home screen → Customize → App Drawer |
| Gestures | Lawnchair Settings → Gestures |
| Hide apps | Lawnchair Settings → General → Hidden Apps |
| App drawer groups | Long-press app in drawer → Edit → Group |
| Icon pack | Lawnchair Settings → General → Icon Pack |
| Dock settings | Long-press dock → Customize |
| Lock home screen layout | Lawnchair Settings → Home Screen → Lock Home Screen |
| Notification dots | Lawnchair Settings → Notifications |
| Screen rotation | Lawnchair Settings → General → Allow Rotation |

---

## 5. Dashboard Configuration

> **Status: ⏳ PENDING** — layout to be built in Phase 3.

### Design Principles

- **Single screen.** Everything accessible without swipe or scroll.
- **Black background** (#000000) — battery conservation on AMOLED; reduces visibility signature at night.
- **Amber or green icon labels** (#FFA500 or #00FF41) — readable at arm's length in low light.
- **No distractions.** No clock widget, no weather feed, no notification badges from non-essential apps.
- **Glove-operable.** All tap targets minimum 48dp. Glove Mode must be enabled at OS level before configuring layout.

### Recommended Grid

**6 columns × 6 rows** — provides 36 tile positions on a 10.1" screen at a size usable with insulated gloves.

### Dashboard Zone Layout

| Zone | Content | App / Widget |
|---|---|---|
| Top Bar — Left | GPS Coordinates Widget | Live lat/long — no tap required |
| Top Bar — Right | Battery % Indicator | Power status at a glance |
| Center (2×2 Large Tile) | Layla (AI Interface) | Primary intelligence layer — largest tile |
| Left Column | Kiwix Reader | 244GB offline knowledge base |
| Left Column | OsmAnd | Offline navigation — Alaska OBF |
| Left Column | Meshtastic | LoRa mesh communications |
| Right Column | Briar | Bluetooth/WiFi P2P encrypted comms |
| Right Column | First Aid IFRC | Medical reference |
| Bottom Row | Seek by iNaturalist | Plant / fauna / fungi ID |
| Bottom Row | Compass Widget | Hardware compass — no GPS required |
| Bottom Row | IR Camera Shortcut | Night vision — direct launch |

### Icon Pack

> **Status: ⏳ TBD** — select and apply in Phase 3.

Recommended criteria for this build: dark-themed, high contrast, minimal detail (readable at glove-distance), covers all apps in the stack. No playful or colorful consumer-oriented packs.

### Gesture Configuration

| Gesture | Action | Path |
|---|---|---|
| Swipe down on home screen | Notification shade | Settings → Gestures → Swipe Down |
| Double-tap home screen | Screen off | Settings → Gestures → Double Tap |
| Swipe up on home screen | App drawer | Settings → Gestures → Swipe Up |
| Long-press home screen | Customize menu | Default behavior |

---

## 6. Hide Apps Configuration

> **Status: ⏳ PENDING** — populate in Phase 3 after all apps are installed and validated.

Apps that remain installed (for system stability) but must not appear in the drawer or home screen.

```
Lawnchair Settings → General → Hidden Apps
```

Candidates — confirm each is safe to hide before adding:

| App | Reason to Hide |
|---|---|
| Play Store | No network — non-functional; removed from view |
| Chrome | No network — non-functional; removed from view |
| Gmail | No network — non-functional; removed from view |
| Google Assistant | Disabled at OS level — no surface needed |
| Oukitel-origin stubs | Any surviving stubs from Phase 0d debloat |

> **Note:** Hiding an app in Lawnchair does not uninstall it. It remains on the device and can be re-surfaced via Settings → Hidden Apps at any time. This is the correct approach for system-dependency apps that must stay installed but should not appear in the mission interface.

---

## 7. App Drawer Groups

> **Status: ⏳ PENDING** — configure in Phase 3.

Lawnchair supports named groups in the app drawer. Recommended group structure for this build:

| Group Name | Apps |
|---|---|
| INTELLIGENCE | Layla, Kiwix |
| NAVIGATION | OsmAnd, Compass |
| COMMS | Meshtastic, Briar |
| MEDICAL | First Aid IFRC, Kiwix (Medical) |
| FIELD | Seek by iNaturalist, VLC, Amaze File Manager |
| SYSTEM | Settings, Developer Options shortcut |

---

## 8. Kiosk-Equivalent Lockdown (Phase 5)

Lawnchair does not have a dedicated Kiosk Mode like Nova Prime. The equivalent is achieved through two Android-native mechanisms:

**Step 1 — Lock the home screen layout:**
```
Lawnchair Settings → Home Screen → Lock Home Screen → ON
```
Prevents accidental icon moves or deletion.

**Step 2 — Enable Android App Pinning:**
```
Settings → Security → App Pinning → Enable
```
Once pinned, the device is locked to a single app until PIN is entered. Use this when handing the device to someone for a specific task (map navigation, medical reference) without exposing the full interface.

**Step 3 — Hide non-mission apps** (see Section 6 above).

> Full lockdown (USB Debugging off, Developer Options hidden) is executed in Phase 5. Do not run Phase 5 lockdown until all apps are validated in Phase 4.

---

## 9. Reinstallation Reference

If Lawnchair needs to be reinstalled at any point:

```bash
# Download fresh APK from official source
# https://github.com/LawnchairLauncher/lawnchair/releases

# Verify SHA256 before installing
shasum -a 256 lawnchair.apk

# Reinstall (will overwrite existing installation)
adb install -r lawnchair.apk

# If -r flag fails, uninstall first then reinstall
adb shell pm uninstall app.lawnchair
adb install lawnchair.apk

# Reset default launcher after reinstall (on-device)
# Settings → Apps → Default Apps → Home App → Lawnchair
```

---

## 10. Build Checklist

- [x] Nova Launcher uninstalled
- [x] Lawnchair 15 Beta 2.1 installed via ADB
- [x] SHA256 verified prior to install
- [x] Set as default launcher (on-device)
- [x] Installation verified via `adb shell pm list packages`
- [ ] Grid set to 6×6
- [ ] Icon size configured for glove operation
- [ ] Black background applied
- [ ] Dashboard layout built (Phase 3)
- [ ] Icon pack selected and applied
- [ ] Gestures configured
- [ ] Hidden apps list populated
- [ ] App drawer groups created
- [ ] Home screen layout locked
- [ ] Validated in Phase 4
- [ ] App Pinning enabled (Phase 5)

---

*BunkerAI-RT7 Alaska Edition*
*Zero-Dark-Access | Open Architecture | Alaska-Hardened*
*Interior Alaska AO — Fairbanks / Fort Wainwright / Chena River drainage*