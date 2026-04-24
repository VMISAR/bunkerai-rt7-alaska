# Validation Checklist

This checklist defines the minimum validation standard before the BunkerAI-RT7 Alaska Edition is considered field-ready.

Validation should be performed on the RT7 itself, using the MicroSD card and applications intended for field use.

## Validation Rules

- Do not mark an item complete until it has been tested directly on the RT7.
- Test in airplane mode unless the item specifically requires local peer-to-peer communication.
- Reboot the RT7 and retest critical functions.
- Record failures in `TROUBLESHOOTING.md` or the build log before attempting fixes.
- Do not rely on a file being present. The file must open in the intended application.

## Core Device Readiness

| Check | Pass / Fail | Notes |
|---|---|---|
| RT7 boots without corruption warning beyond known accepted state |  |  |
| Battery charges from wall power |  |  |
| Battery charges from field solar setup |  |  |
| Glove mode enabled and usable |  |  |
| Screen brightness adequate outdoors |  |  |
| Airplane mode enabled |  |  |
| Wi-Fi, cellular, Bluetooth, and GPS settings documented |  |  |
| Reboot completed after final app setup |  |  |

## Launcher / Dashboard

| Check | Pass / Fail | Notes |
|---|---|---|
| Lawnchair is set as default launcher |  |  |
| Dashboard layout matches documented operating concept |  |  |
| Critical apps accessible from home screen |  |  |
| Non-mission apps hidden or removed from primary workflow |  |  |
| Icons and labels readable with gloves / cold-weather use |  |  |
| Dashboard remains stable after reboot |  |  |

## Offline AI

| Check | Pass / Fail | Notes |
|---|---|---|
| ChatterUI opens without account login |  |  |
| Primary model loads successfully |  |  |
| Backup model loads successfully |  |  |
| Model responds while in airplane mode |  |  |
| Medical/survival prompt template tested |  |  |
| Repair/troubleshooting prompt template tested |  |  |
| AI response speed is acceptable for field use |  |  |

## Offline Knowledge

| Check | Pass / Fail | Notes |
|---|---|---|
| Kiwix opens without account login |  |  |
| Wikipedia ZIM opens |  |  |
| WikiHow ZIM opens |  |  |
| iFixit ZIM opens |  |  |
| Medical ZIM opens |  |  |
| Stack Exchange ZIM sample opens |  |  |
| Search works inside Kiwix |  |  |
| Content remains accessible after reboot |  |  |

## Maps / Navigation

| Check | Pass / Fail | Notes |
|---|---|---|
| OsmAnd opens without account login |  |  |
| Alaska offline map loads |  |  |
| Location display works without cellular service |  |  |
| Offline route test completed |  |  |
| At least three USGS GeoPDF topo maps open |  |  |
| Priority AO map coverage confirmed |  |  |

## Medical / First Aid

| Check | Pass / Fail | Notes |
|---|---|---|
| First aid app opens offline |  |  |
| Bleeding / laceration reference tested |  |  |
| Hypothermia reference tested |  |  |
| Burn treatment reference tested |  |  |
| Fracture / splinting reference tested |  |  |
| Medical PDFs open in intended reader |  |  |

## Communications

| Check | Pass / Fail | Notes |
|---|---|---|
| Meshtastic app opens |  |  |
| Meshtastic pairs with LoRa device |  |  |
| Test message sent and received |  |  |
| Briar opens without cloud dependency |  |  |
| Briar local contact workflow tested |  |  |
| Communications limitations documented |  |  |

## File System / Storage

| Check | Pass / Fail | Notes |
|---|---|---|
| MicroSD card mounts after reboot |  |  |
| BunkerAI folder structure visible in file manager |  |  |
| Large ZIM file opens from MicroSD |  |  |
| Large PDF opens from MicroSD |  |  |
| Remaining free space checked |  |  |
| File manager can browse all mission folders |  |  |

## Final Lockdown

| Check | Pass / Fail | Notes |
|---|---|---|
| Public repository redactions confirmed |  |  |
| App list documented |  |  |
| Content manifest updated |  |  |
| Known limitations documented |  |  |
| Recovery path documented |  |  |
| Final reboot completed |  |  |
| Operator card reviewed |  |  |
| Field case packed and checked |  |  |

## Final Validation Statement

The BunkerAI-RT7 Alaska Edition should not be considered field-ready until all mission-critical checks are marked passing or known limitations are clearly documented.

