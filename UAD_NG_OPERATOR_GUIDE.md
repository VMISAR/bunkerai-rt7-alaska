# UAD_NG_OPERATOR_GUIDE.md
**Project:** BunkerAI-RT7 Alaska Edition  
**Hardware:** Oukitel RT7 Titan 5G (Android 15)  
**Host Machine:** MacBook Air (macOS)

---

## Phase 1: The Digital Handshake (RT7 Side)
Before the MacBook can communicate with the tablet, the RT7 must be placed into a state that allows low-level system commands.

1.  **Open Settings** on the RT7.
2.  Navigate to **About Tablet**.
3.  Scroll to the bottom and tap **Build Number** exactly **seven (7) times**. A toast notification will appear saying *"You are now a developer!"*
4.  Go back to the main **Settings** menu.
5.  Navigate to **System** -> **Developer Options**.
6.  Scroll down to **USB Debugging** and toggle it **ON**.
7.  Connect the RT7 to the MacBook Air using a high-quality USB-C cable.
8.  **Watch the RT7 Screen:** A prompt will appear asking to *"Allow USB Debugging?"* Check the box for **"Always allow from this computer"** and tap **Allow**.

---

## Phase 2: Verifying the Connection (MacBook Side)
Confirm the bridge is active before launching the debloater interface.

1.  Open **Terminal** on the MacBook.
2.  Type the following command:
    ```bash
    adb devices
    ```
3.  **Expected Result:** You should see a serial number followed by the word `device`. If it says `unauthorized`, check the RT7 screen for the prompt mentioned in Phase 1.

---

## Phase 3: Launching UAD-NG
Since the tool was installed via Homebrew, it is linked to the system path and must be triggered via Terminal to ensure it inherits the ADB environment.

1.  In the Terminal, type:
    ```bash
    universal-android-debloater
    ```
2.  The Graphical User Interface (GUI) will open in a new window.

---

## Phase 4: Pre-Flight Package Export
Create a baseline record of every package currently on the device. This is the "Recovery Map" if a future Batch causes a boot loop.

1.  Open a second Terminal tab (Command + T) and run:
    ```bash
    adb shell pm list packages -f > ~/Desktop/RT7_Factory_Baseline.txt
    ```

---

## Phase 5: Identification and Surgical Debloating
The GUI will automatically populate with a list of packages. UAD-NG uses its internal database to categorize them by risk level.

### 1. Understanding the Filters
In the top-right dropdown, you will see the following categories:
* **Recommended:** 100% safe. These are typically Google tracking, marketing apps, and redundant tools.
* **Advanced:** Generally safe, but may remove secondary features (e.g., a specific Oukitel widget).
* **Expert:** **High Risk.** This is where MediaTek system services reside.
* **Unsafe:** Known boot-loop triggers. UAD-NG will hide these by default.

### 2. The Debloat Process
1.  Set the filter to **Recommended**.
2.  Select the packages you wish to remove.
3.  Click **Uninstall** in the bottom right.
4.  **Reboot the RT7** to ensure it clears the splash screen before moving to the next level.

---

## Phase 6: Managing the "Batch 3" MediaTek Risk
To avoid the boot loop encountered during manual ADB attempts, use the description box in UAD-NG for any MediaTek (`com.mediatek.*`) or Oukitel (`com.wtk.*`) packages.

1.  Set the filter to **Expert**.
2.  Type `mediatek` into the search bar.
3.  **Read the Description:** When you click a package, UAD-NG will display its function at the bottom.
4.  If the description mentions **"Boot," "Init," "NVRAM," or "Modem,"** immediately click **Add to Whitelist** to prevent accidental removal.

---

## Phase 7: Emergency Package Restoration
If the tablet exhibits unstable behavior or a specific hardware feature (like the IR Camera) stops working, you can restore the package without a factory reset.

1.  In the UAD-NG GUI, change the status filter from "Installed" to **"Uninstalled"**.
2.  Find the package you recently removed.
3.  Click **Restore**.
4.  **Terminal Backup Method:** If the GUI is unresponsive, run this command in Terminal:
    ```bash
    adb shell pm install-existing [package.name]
    ```

---
*Reference for: BunkerAI-RT7 | Interior Alaska AO*