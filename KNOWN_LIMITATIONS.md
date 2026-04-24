# Known Limitations

This file records known limitations, assumptions, incomplete validations, and deliberate exclusions for the BunkerAI-RT7 Alaska Edition.

The goal is to keep the project honest, reproducible, and useful for future maintainers.

## Status Categories

| Status | Meaning |
|---|---|
| Confirmed | Tested directly on the RT7 |
| Pending Validation | Planned or installed but not yet fully tested |
| Assumed | Believed to work based on documentation or prior use, but not yet confirmed on this build |
| Deliberately Excluded | Not included because it conflicts with the mission, increases risk, or creates unnecessary complexity |
| Known Risk | Accepted risk that should be understood before field use |

## Current Known Limitations

| Area | Limitation | Status | Notes |
|---|---|---|---|
| Offline AI | Model quality and speed may vary by GGUF model, quantization, and prompt length | Pending Validation | Validate actual response time and usefulness on the RT7 |
| Offline AI | AI output should not be treated as authoritative medical, legal, or safety guidance | Known Risk | Use AI as a reasoning aid, not as a replacement for verified references |
| Medical References | Medical content may become outdated | Known Risk | Refresh periodically and prioritize reputable offline references |
| Regulations | Alaska hunting, fishing, and subsistence regulations change annually | Known Risk | Refresh before any real-world use |
| Maps | OsmAnd and USGS topo coverage may not include every needed route, trail, or hazard | Known Risk | Validate intended AO before field deployment |
| GPS | GPS behavior without cellular/Wi-Fi assistance may vary by location and conditions | Pending Validation | Test cold-start GPS outdoors |
| Communications | Meshtastic requires compatible LoRa hardware and proper local configuration | Pending Validation | Validate pair, send, receive, and range |
| Communications | Briar requires local peer setup before it is useful in the field | Pending Validation | Validate contact exchange and offline workflow |
| Power | Solar charging performance will vary by season, temperature, cloud cover, and panel angle | Known Risk | Validate with the actual field charging setup |
| Cold Weather | Battery performance may degrade significantly in extreme cold | Known Risk | Keep device insulated and test realistic cold-weather behavior |
| Storage | MicroSD card reliability is a single point of failure for the offline library | Known Risk | Consider backup card or cloned image |
| Recovery | Firmware flashing and test-point recovery are high-risk procedures | Known Risk | Do not attempt without verified files, tools, and a clear recovery plan |
| Public Documentation | Some private details are intentionally omitted | Confirmed | Public repo favors reproducibility without exposing private identifiers |

## Deliberately Excluded

| Exclusion | Reason |
|---|---|
| Private account credentials | Not appropriate for a public repository |
| Device serial numbers / IMEI / MEID | Unnecessary device fingerprinting risk |
| Personal local file paths | Not reproducible and exposes private machine details |
| Precise private GPS coordinates | Unnecessary location exposure |
| Aggressive Android debloat instructions | Prior debloat attempt caused serious recovery issues |
| Unsupported claims of superiority over commercial products | Public claims should remain defensible |

## Validation Priority

Before field use, prioritize validation in this order:

1. RT7 boots cleanly and MicroSD mounts after reboot.
2. Kiwix opens core ZIM libraries offline.
3. OsmAnd opens Alaska maps offline.
4. Medical references open offline.
5. ChatterUI loads the primary AI model offline.
6. Operator card and critical PDFs open from local storage.
7. Power/charging setup works with field hardware.
8. Communications tools work with actual paired devices.

## Maintenance Note

When a limitation is resolved, update this file instead of deleting the issue entirely. Move the item into a resolved note or update the status to `Confirmed` so future maintainers understand what was tested.