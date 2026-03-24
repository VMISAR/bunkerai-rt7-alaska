# Phase 3 — Dashboard Configuration (Nova Launcher)

**Theme:** Alaska-Hardened Terminal  
**Primary Color:** Amber (#FFA500) — *High visibility in snow/low light* **Secondary Color:** Phosphorus Green (#00FF41) — *Classic NVG aesthetic* **Background:** Pure Black (#000000) — *OLED/IPS battery preservation*

---

## 1. Global Nova Settings

Before placing widgets, set the foundational UI behavior to ensure the "Single Interface" constraint is met.

| Setting | Selection | Reason |
| :--- | :--- | :--- |
| **Home Screen Grid** | 12 x 8 | Maximum density for the 10.1" display |
| **Icon Layout** | 80% size / Labels OFF | Reduces visual clutter; rely on app icons |
| **Dock** | Disabled | Force all interaction to the main dashboard |
| **Look & Feel** | "Dark" Theme | Global system matching |
| **App Animation** | "None" or "Fast" | Perceived performance during high CPU load (AI inference) |

---

## 2. The Dashboard Layout (The "Mission Computer" View)

Map the 12x8 grid into functional zones.

### **Zone A: Top Status Bar (Telemetry)**
* **GPS Coordinates Widget:** (Top Left) 2x2 block. Use "GPS Status & Toolbox" or similar to display live Lat/Long. No tap required.
* **Battery/Solar Monitor:** (Top Right) 2x2 block. Visual percentage and temperature (critical for Fairbanks winters).

### **Zone B: Central Core (Intelligence)**
* **Layla AI Widget:** (Center) 6x6 block. This is your primary interface. Ensure the "Ask anything" text bar is prominent.
* **Quick Action:** Map "Swipe Up" on the Layla icon to launch the specific "Laceration/Medical" prompt template.

### **Zone C: Left Column (Tactical & Nav)**
* **OsmAnd:** (Row 3, Col 1) Large icon.
* **Kiwix:** (Row 4, Col 1) Large icon.
* **Meshtastic:** (Row 5, Col 1) Large icon.

### **Zone D: Right Column (Comms & Medical)**
* **Briar:** (Row 3, Col 8) Large icon.
* **First Aid IFRC:** (Row 4, Col 8) Large icon.
* **Seek:** (Row 5, Col 8) Large icon.

---

## 3. Visual Styling (Amber/Green Overlay)

To achieve the "Alaska-Hardened" look without a custom ROM, use Nova's icon and font overrides:

1.  **Icon Pack:** Use "Lines Free" or "Whicons" forced to **Amber (#FFA500)** using a filter app or Nova's native "Recolor" if available.
2.  **Widget Backgrounds:** Set all widget backgrounds to 80% transparency black with a **1pt Green (#00FF41)** border.
3.  **Font:** If possible, use a monospaced font like *Roboto Mono* or *Courier New* for all labels.

---

## 4. Kiosk Lockdown Preparation

*Reference: Phase 5 Checklist*

* **Disable Notifications:** Nova Settings → Notifications → OFF (prevents distraction/telemetry popups).
* **Lock Desktop:** Nova Settings → Home Screen → Advanced → Lock Desktop. This prevents accidental icon dragging while wearing gloves.
* **Gestures:** * *Double Tap:* Launch IR Camera (Night Vision).
    * *Two-Finger Swipe Down:* Open Amaze File Manager (for CD3WD ISOs).

---

## 5. Validation Checklist

- [ ] Does the "Home" button always return to this exact screen?
- [ ] Are GPS coordinates legible from 3 feet away?
- [ ] Can the IR Camera be launched in under 2 seconds?
- [ ] Do all icon colors match the #FFA500 / #00FF41 scheme?

---
*Drafted for: BunkerAI-RT7 Alaska Edition* *Interior Alaska AO — Zero-Dark-Access*