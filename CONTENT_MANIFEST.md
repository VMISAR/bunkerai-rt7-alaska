# Content Manifest

This manifest tracks the offline content loaded onto the BunkerAI-RT7 Alaska Edition MicroSD card.

Its purpose is to make the build reproducible, auditable, and easier to refresh over time.

## Manifest Rules

- Every major offline content package should have one row.
- Use the most specific version, release date, download date, or file date available.
- Record checksums for large or mission-critical files.
- Mark validation status only after the file opens successfully on the RT7.
- Do not include private download paths, personal account information, credentials, device serial numbers, or other sensitive details.

## Status Key

| Status | Meaning |
|---|---|
| Planned | Identified but not downloaded |
| Staged | Downloaded to computer or external drive |
| Transferred | Copied to RT7 MicroSD |
| Validated | Opened and tested successfully on RT7 |
| Replace | Present but should be replaced or refreshed |
| Remove | Present but should be deleted |

## Offline Content Manifest

| Category | Content / File | Source | Version / Date | Approx. Size | MicroSD Location | Checksum | Status | Notes |
|---|---|---|---|---:|---|---|---|---|
| AI Model | Phi-3 Mini GGUF | Hugging Face / model source | TBD | TBD | `/sdcard/BunkerAI/AI_Models/` | TBD | Transferred | Validate in ChatterUI |
| AI Model | Phi-3.5 Mini GGUF | Hugging Face / model source | TBD | TBD | `/sdcard/BunkerAI/AI_Models/` | TBD | Transferred | Validate in ChatterUI |
| Knowledge | Wikipedia ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Knowledge | Wikibooks ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Knowledge | Wikiversity ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Knowledge | Wikivoyage ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Knowledge | WikiHow ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Knowledge | iFixit ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/` | TBD | Transferred | Validate in Kiwix |
| Medical | Wikipedia Medicine ZIM | Kiwix Library | TBD | TBD | `/sdcard/BunkerAI/Kiwix/Medical/` | TBD | Transferred | Validate search and article load |
| Medical | MedlinePlus / First Aid References | Public medical sources | TBD | TBD | `/sdcard/BunkerAI/Medical/` | TBD | Transferred | Validate PDF/app access |
| Maps | OsmAnd Alaska Map | OsmAnd | TBD | TBD | App-managed storage | TBD | Transferred | Validate offline map and route |
| Maps | USGS GeoPDF Topos | USGS TopoView | TBD | TBD | `/sdcard/BunkerAI/Maps/USGS/` | TBD | Transferred | Validate at least 3 sample PDFs |
| Regulations | Alaska Hunting Regulations | Alaska Department of Fish and Game | 2025-2026 | TBD | `/sdcard/BunkerAI/ADFG/` | TBD | Transferred | Refresh annually |
| Regulations | GMU20 Interior Alaska Regulations | Alaska Department of Fish and Game | 2025-2026 | TBD | `/sdcard/BunkerAI/ADFG/` | TBD | Transferred | Refresh annually |
| Regulations | Subsistence Fishing Regulations | Alaska Department of Fish and Game | 2025-2026 | TBD | `/sdcard/BunkerAI/ADFG/` | TBD | Transferred | Refresh annually |
| Repair | Stack Exchange ZIMs | Kiwix Library | 2026-02 where available | TBD | `/sdcard/BunkerAI/Kiwix/StackExchange/` | TBD | Transferred | Validate representative files |
| Literature | Project Gutenberg Agriculture volume | Project Gutenberg / public domain source | TBD | TBD | `/sdcard/BunkerAI/Books/` | TBD | Transferred | Validate PDF/ePub reader |
| Agriculture | CD3WD / Appropriate Technology Library | Public archive source | TBD | TBD | `/sdcard/BunkerAI/CD3WD/` | TBD | Transferred | Validate folder navigation |

## Refresh Cadence

| Content Type | Recommended Refresh |
|---|---|
| Alaska hunting/fishing/subsistence regulations | Annually, before season use |
| OsmAnd maps | Quarterly or before field deployment |
| USGS topo PDFs | Annually or when AO changes |
| Kiwix ZIM libraries | Semiannually |
| AI models | Only after deliberate testing |
| Medical references | Semiannually |
| Apps/APKs | Quarterly, before final lockdown |

## Checksum Procedure

On macOS, generate a checksum with:

```bash
shasum -a 256 "filename"

```

Record the output in the `Checksum` column.

## Validation Procedure

A file should not be marked `Validated` until it has been opened directly on the RT7 from the intended application.

Minimum validation standard:

1. File opens without error.
2. Search or navigation works where applicable.
3. Content remains available in airplane mode.
4. Content remains available after reboot.
5. App does not require cloud login or account activation.
