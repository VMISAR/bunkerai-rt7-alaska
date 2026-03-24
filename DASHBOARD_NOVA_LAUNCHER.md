# Dashboard Configuration — Nova Launcher
## BunkerAI-RT7 Alaska Edition

**Theme:** Alaska-Hardened Terminal
**Status:** ITERATIVE — verify each element on device before marking complete
**Last Updated:** March 23, 2026

---

## How to Use This Document

Each configuration item is tagged:

- ✅ **Confirmed** — works in Nova Launcher, verified or well-documented
- 🔬 **Needs Testing** — should work but unverified on this specific device/build
- ⚠️ **Aspirational** — desired behavior that may require a workaround or third-party app
- ❌ **Not Possible in Nova** — confirmed limitation; workaround documented

Update tags as you test each item on the RT7.

---

## 1. Global Nova Settings

| Setting | Target Value | Status | Notes |
|---|---|---|---|
| Home Screen Grid | 12 x 8 | 🔬 Needs Testing | Maximum density for 10.1" display — verify readability with gloves |
| Icon Size | 80% | 🔬 Needs Testing | Reduces clutter; verify touch target size with gloves |
| Icon Labels | OFF | ✅ Confirmed | Nova setting: Desktop → Icon Layout → Label |
| Dock | Disabled | ✅ Confirmed | Nova Settings → Desktop → Dock → disable |
| Theme | Dark | ✅ Confirmed | Nova Settings → Look & Feel → Dark |
| App Animation | None or Fast | ✅ Confirmed | Nova Settings → Desktop → Scroll Effect → None |
| Lock Desktop | ON | ✅ Confirmed | Nova Settings → Desktop → Advanced → Lock Desktop — prevents accidental drag with gloves |

---

## 2. Dashboard Layout — Zone Map

Grid: 12 columns × 8 rows on a 10.1" FHD+ display.

```
┌────────────────────────────────────────────┐
│  [GPS Widget 3x2]        [Battery 3x2]     │  ← Zone A: Telemetry (Row 1-2)
├──────────┬─────────────────────┬───────────┤
│          │                     │           │
│ OsmAnd   │                     │  Briar    │
│ Kiwix    │    LAYLA  4x4       │  First Aid│  ← Zone B+C+D (Rows 3-6)
│Meshtastic│                     │  Seek     │
│          │                     │           │
├──────────┴─────────────────────┴───────────┤
│  [IR Camera]  [Compass]  [Amaze]  [VLC]    │  ← Zone E: Bottom Row (Rows 7-8)
└────────────────────────────────────────────┘
```

> **Why Layla is 4x4, not 6x6:** A 6x6 block (37% of screen) over-prioritizes AI at the expense of navigation and comms. In a real field scenario, OsmAnd and Kiwix get more daily use. 4x4 keeps Layla dominant without crowding out the tactical column.

---

## 3. Zone A — Telemetry Bar (Rows 1–2)

### GPS Coordinates Widget
- **App:** GPS Status & Toolbox (free, no internet required)
- **Widget:** "GPS Info" widget — displays live Lat/Long
- **Size:** 4x2 block, top left
- **Status:** 🔬 Needs Testing — confirm widget displays without Google Play Services active

### Battery Monitor
- **App:** Battery Widget Reborn or GSAM Battery Monitor
- **Widget:** Percentage + temperature display
- **Size:** 4x2 block, top right
- **Status:** 🔬 Needs Testing — confirm temperature readout works (critical for Fairbanks cold)
- **Note:** Battery temperature warning is operationally important below -20°F

---

## 4. Zone B — Central Core (Rows 3–6, Cols 3–10)

### Layla AI
- **Type:** App shortcut (icon), not a widget
- **Size:** 4x4 block — largest single element on the dashboard
- **Status:** ⚠️ Aspirational — Layla likely does not have a home screen widget; this will be an oversized icon shortcut
- **Workaround:** Use Nova's icon resize feature to enlarge the Layla shortcut to fill the 4x4 zone

### Pre-loaded Medical Prompt Shortcut
- **Desired:** Tap → Layla opens with laceration/trauma query pre-loaded
- **Status:** ❌ Not possible natively in Nova or Layla
- **Workaround options:**
  1. **Tasker + AutoInput** — create a task that opens Layla and pastes a pre-written prompt. Requires Tasker ($3.49) and AutoInput plugin.
  2. **Android Shortcut** — some AI apps support URL scheme shortcuts with pre-loaded text. Test if Layla supports this.
  3. **Interim solution:** Create a text file in Amaze with your top 5 field prompts. One tap opens the file; copy/paste into Layla. Not elegant but zero dependencies.
- **Recommendation:** Test Option 3 first. If Tasker is added to the build, revisit Option 1.

---

## 5. Zone C — Left Column (Rows 3–6, Cols 1–2)

| Row | App | Icon Size | Status |
|---|---|---|---|
| 3 | OsmAnd | Large | ✅ Confirmed |
| 4 | Kiwix | Large | ✅ Confirmed |
| 5 | Meshtastic | Large | ✅ Confirmed |
| 6 | (spare) | — | Reserve for Phase 2 addition |

---

## 6. Zone D — Right Column (Rows 3–6, Cols 11–12)

| Row | App | Icon Size | Status |
|---|---|---|---|
| 3 | Briar | Large | ✅ Confirmed |
| 4 | First Aid IFRC | Large | ✅ Confirmed |
| 5 | Seek by iNaturalist | Large | ✅ Confirmed |
| 6 | (spare) | — | Reserve for Phase 2 addition |

---

## 7. Zone E — Bottom Row (Rows 7–8)

| Position | App | Status | Notes |
|---|---|---|---|
| Col 1–2 | IR Camera shortcut | 🔬 Needs Testing | Confirm shortcut targets IR mode directly, not standard camera |
| Col 3–4 | Compass widget | 🔬 Needs Testing | Hardware compass — confirm works in Airplane Mode |
| Col 5–6 | Amaze File Manager | ✅ Confirmed | For CD3WD ISO browsing |
| Col 7–8 | VLC | ✅ Confirmed | For PDF topos and media |
| Col 9–10 | (spare) | — | |
| Col 11–12 | (spare) | — | |

---

## 8. Visual Styling

### Color Scheme
| Element | Color | Hex | Status |
|---|---|---|---|
| Background | Pure Black | #000000 | ✅ Confirmed — Nova wallpaper setting |
| Primary accent | Amber | #FFA500 | 🔬 Needs Testing — see icon note |
| Secondary accent | Phosphor Green | #00FF41 | 🔬 Needs Testing |

### Icon Recoloring
- **Desired:** All icons in amber #FFA500
- **Status:** ⚠️ Aspirational — Nova does not natively recolor icon packs
- **Realistic options:**
  1. **Themed icon pack:** Search "dark amber icon pack" or "terminal icon pack" on APKPure. Many are pre-styled in amber/green with no recoloring needed.
  2. **KLWP / Kustom:** Full custom icon theming — steep learning curve, powerful result.
  3. **Interim:** Use a dark minimal icon pack (Whicons, Lines Free) — accept white icons on black background. Functional if not aesthetically perfect.
- **Recommendation:** Start with a pre-made amber/terminal icon pack. Don't invest Tasker-level effort into icon color until the functional layout is validated.

### Font
- **Desired:** Roboto Mono or Courier New (monospaced)
- **Status:** ⚠️ Aspirational — Nova supports custom fonts in Prime version; confirm RT7 compatibility
- **Workaround:** Nova Prime → Look & Feel → Font — test Roboto Mono installation

---

## 9. Gestures

| Gesture | Target Action | Status | Notes |
|---|---|---|---|
| Double Tap Home | IR Camera | ✅ Confirmed | Nova Settings → Gestures → Double Tap |
| Two-Finger Swipe Down | Amaze File Manager | ✅ Confirmed | Nova Settings → Gestures → Two-Finger Swipe Down |
| Swipe Up (Layla icon) | Medical prompt template | ❌ Not possible natively | See Zone B workaround options |
| Long Press Home | Nova Settings | ✅ Confirmed | Default Nova behavior |

---

## 10. Kiosk Lockdown (Phase 5 — Not Yet Applied)

Do not apply these until all apps are installed and validated.

- [ ] Nova Settings → Notifications → OFF
- [ ] Nova Settings → Desktop → Advanced → Lock Desktop → ON
- [ ] Settings → Apps → Default Apps → Home App → Nova Launcher (already set)
- [ ] Disable USB Debugging after final content transfer
- [ ] Hide Developer Options: `adb shell settings put global development_settings_enabled 0`

---

## 11. Iteration Log

Use this section to track what you tested and what the result was.

| Date | Item Tested | Result | Next Step |
|---|---|---|---|
| — | Nova Launcher installed as default | ✅ Complete | Begin layout |
| — | 12x8 grid readability with gloves | | |
| — | GPS widget — offline display | | |
| — | Battery temperature widget | | |
| — | Layla icon sizing in 4x4 zone | | |
| — | IR Camera shortcut mode | | |
| — | Double-tap gesture → IR Camera | | |
| — | Amber icon pack selection | | |

---

## 12. Validation Checklist

Before moving to Phase 5 lockdown, all items below must pass:

- [ ] Home button always returns to this exact screen
- [ ] GPS coordinates displayed without tapping — readable at arm's length
- [ ] IR Camera launches in under 3 seconds from home screen
- [ ] All Zone C and D apps launch cleanly in Airplane Mode
- [ ] Layla loads and accepts input in Airplane Mode
- [ ] No notifications or system popups visible on dashboard
- [ ] Lock Desktop confirmed — icons cannot be accidentally dragged while wearing gloves

---

*BunkerAI-RT7 Alaska Edition — Dashboard Configuration*
*Iterative document — update tags as each item is tested on device*
*Interior Alaska AO — Zero-Dark-Access*
