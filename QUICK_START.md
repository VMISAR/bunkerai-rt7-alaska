# Quick Start Guide

This guide provides a sanitized, high-level build path for the BunkerAI-RT7 Alaska Edition.

It is intended for public use and does not include private device identifiers, personal file paths, credentials, or account-specific configuration.

## Intended Outcome

A rugged Android tablet configured as an offline survival, repair, medical, navigation, and reference terminal for Interior Alaska field conditions.

## Hardware Baseline

- Oukitel RT7 Titan 5G tablet
- High-endurance or high-performance MicroSD card
- Rugged protective case
- USB-C charging equipment
- Field solar charging setup
- Optional LoRa / Meshtastic device

## Software Baseline

- Offline launcher/dashboard
- Offline AI chat application
- Local GGUF AI model
- Kiwix for ZIM libraries
- OsmAnd for offline maps
- PDF reader
- File manager
- First aid / medical reference app
- Meshtastic and/or Briar for local communications

## Build Sequence

### 1. Stabilize the Tablet

- Fully charge the RT7.
- Complete the normal Android setup.
- Enable developer options only if needed.
- Avoid aggressive debloating.
- Confirm the tablet reboots cleanly.

### 2. Prepare Storage

- Format and mount the MicroSD card.
- Create the intended folder structure.
- Transfer content in categories instead of one giant unsorted copy.
- Keep a record of major content packages in `CONTENT_MANIFEST.md`.

Recommended folder structure:

```text
/sdcard/BunkerAI/
  ADFG/
  AI_Models/
  Books/
  CD3WD/
  Kiwix/
  Maps/
  Medical/
  Operators/
  Repair/