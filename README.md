# BunkerAI-RT7 Alaska Edition

## Public Repository Notice

This repository is written as a public, reproducible documentation project. Device-specific identifiers, private file paths, credentials, account details, and personally sensitive configuration data are intentionally omitted or redacted.

The documentation preserves the build architecture, recovery lessons, operating concept, and validation approach while avoiding unnecessary exposure of private device or user information.


**A fully self-contained, air-gapped survival intelligence terminal built on the Oukitel RT7 Titan 5G**

> *Zero-Dark-Access | Open Architecture | Alaska-Hardened*

---

## What This Is

This is a complete build log documenting how to turn an Oukitel RT7 Titan 5G rugged tablet into a fully offline survival intelligence terminal — no internet, no cellular, no cloud. Everything runs from a SanDisk Extreme MicroSD card loaded with AI models, offline knowledge libraries, topographic maps, and communications tools.

The design baseline was the commercial [BunkerAI "BOB" tablet](https://bunkerai.io/) ($799). This project documents an open, self-managed alternative designed to emphasize battery capacity, ruggedness, offline AI capability, local ownership of files, and reproducibility at a lower hardware cost.

This is not a theoretical build. It's a documented, in-progress build with real mistakes, a real boot loop incident, and real decisions made under real constraints in Interior Alaska.

---

## Why the RT7

| Spec | RT7 Titan | Why It Matters |
|---|---|---|
| Battery | 32,000mAh | 30+ hours active; months on standby |
| RAM | 12GB physical / 24GB virtual | Runs quantized 4B AI models comfortably |
| Durability | MIL-STD-810H / IP68/IP69K | Waterproof, drop-proof, submersible |
| Screen | 10.1" FHD+ 400 nits + Glove Mode | Readable outdoors, usable with insulated gloves |
| Camera | 20MP + IR (Night Vision) | Passive observation in zero-light conditions |
| Reverse Charging | Yes (OTG) | Acts as a battery bank for family devices |
| Price | ~$400 | Half the cost of the commercial alternative |

---

## The Stack

```
┌─────────────────────────────────────────────┐
│          LAWNCHAIR LAUNCHER DASHBOARD         │
│     (Mission computer UI — one screen)       │
├──────────────┬──────────────────────────────┤
│ AI LAYER     │ ChatterUI + Phi-3 Mini GGUF   │
│ KNOWLEDGE    │ Kiwix + 244GB ZIM library      │
│ NAVIGATION   │ OsmAnd + Alaska OBF           │
│ COMMS        │ Meshtastic (LoRa) + Briar (BT) │
│ MEDICAL      │ First Aid IFRC                │
│ IDENTIFICATION│ Seek by iNaturalist           │
├──────────────┴──────────────────────────────┤
│         SanDisk Extreme 512GB MicroSD        │
│              Android 15 / ARM64              │
└─────────────────────────────────────────────┘
```

---

## Knowledge Library — 244GB Staged

The MicroSD is loaded using a layered knowledge model. Each layer covers a different failure mode:

| Layer | Content | Purpose |
|---|---|---|
| 1 — Encyclopedic | Full Wikipedia (111GB), Wikibooks, Wikiversity, Wikivoyage | General knowledge baseline |
| 2 — Operational | iFixit, WikiHow, Stack Exchange (DIY, Mechanics, Outdoors, Ham, Electronics) | Task-specific repair and construction |
| 3 — Medical | Wikipedia Medicine, MedlinePlus, Military Field Medicine, NHS Drugs, CDC | Pre-hospital trauma and disease reference |
| 4 — Pre-Industrial | Project Gutenberg LCC volumes (53GB), CD3WD ISOs (26GB) | Rebuild-from-scratch knowledge; no modern tools assumed |
| 5 — Alaska-Specific | ADFG hunting/fishing/subsistence regs, USGS GeoPDF topos, OsmAnd Alaska OBF | Interior Alaska operational area |
| 6 — AI Reasoning | Phi-3 Mini + Phi-3.5 Mini GGUF (4.4GB) | Synthesizes all other layers to answer specific questions |
| 7 — Communications | Meshtastic (LoRa mesh), Briar (P2P Bluetooth/WiFi) | Off-grid messaging when cellular is down |

**Total on card: 229GB of ~476GB usable. ~247GB headroom remaining.**

---

## Build Status

| Phase | Status | Notes |
|---|---|---|
| Phase 0 — Hardware Acquisition | ✅ Complete | RT7 in hand |
| Phase 0b — Debloat Attempt 1 | ⚠️ Boot loop | Manual ADB Batch 3 caused boot loop |
| Phase 0c — BROM Recovery | ✅ Complete | PCB test point → BROM mode → SP Flash Tool full firmware flash |
| Phase 0d — Debloat Phase 1 (UAD-NG) | ✅ Complete | UAD-NG GUI + Deep Freeze kill-chain — Silent State achieved |
| Phase 0e — Firmware Reflash | ⏭️ Skipped | Not required — build fully functional without reflash |
| Phase 0f — Launcher Swap (Nova → Lawnchair) | ✅ Complete | Nova replaced with Lawnchair 15 Beta 2.1 — open source, zero telemetry |
| Phase 1 — Content Download | ✅ Complete | 244GB staged across two drives |
| Phase 2 — MicroSD Transfer | ✅ Complete | 229GB confirmed on card — direct Mac copy via exFAT |
| Phase 3 — App Configuration | ⏳ Pending | |
| Phase 4 — Validation | ⏳ Pending | |
| Phase 5 — Final Lockdown | ⏳ Pending | |

---

## Hardware Bill of Materials

| Item | Detail | Notes |
|---|---|---|
| Oukitel RT7 Titan 5G | Primary device | ~$400 |
| SanDisk Extreme 512GB MicroSD (V30/U3) | Content storage | **Must be V30/U3** — Ultra Plus not acceptable |
| FlexSolar 36W Ultra-Portable Solar Panel | Off-grid charging | USB-A, USB-C, and DC ports; Quick Charge; ultra-lightweight |
| Anker PowerLine III Flow USB-C (10ft) | Data transfer + solar charge | 100W rated |
| Pelican 1450 Protector Case | Transport + storage | Custom Pick-N-Pluck foam |

---

## Project Governance and Validation

These files support reproducibility, field-readiness, and long-term maintenance:

| File | Purpose |
|---|---|
| [`QUICK_START.md`](QUICK_START.md) | Provides a sanitized high-level build path for public readers |
| [`CONTENT_MANIFEST.md`](CONTENT_MANIFEST.md) | Tracks offline content, source, version/date, MicroSD location, checksum, and validation status |
| [`VALIDATION_CHECKLIST.md`](VALIDATION_CHECKLIST.md) | Defines the minimum field-readiness validation standard |
| [`MAINTENANCE_SCHEDULE.md`](MAINTENANCE_SCHEDULE.md) | Defines recurring refresh cycles, update rules, and pre-field-use checks |
| [`CHANGELOG.md`](CHANGELOG.md) | Tracks notable public documentation and build-state changes |

## Repository Structure

```
bunkerai-rt7-alaska/
├── README.md                       ← You are here
├── BUILD_LOG.md                    ← Full narrative build log (all phases)
├── LAUNCHER_LAWNCHAIR.md           ← Lawnchair install, config, and decision record
├── TROUBLESHOOTING.md              ← Boot loop incident + recovery steps
├── DEBLOAT_ISSUES.md               ← Debloat reference + Phase 1 results
├── DEBLOAT_OPERATIONS_LOG.md       ← Phase 1 package disposition registry
├── UAD_NG_OPERATOR_GUIDE.md        ← Step-by-step UAD-NG guide for RT7
├── OPERATORS_CARD.md               ← One-page quick reference for field use
└── phases/
    ├── phase0_first_boot.md
    ├── phase0b_debloat_attempt1.md ← Manual ADB — what broke and why
    ├── phase0c_recovery.md         ← BROM + SP Flash Tool recovery
    ├── phase0d_debloat_uadng.md    ← UAD-NG Phase 1 — COMPLETE
    ├── phase0f_launcher_swap.md    ← Nova → Lawnchair — COMPLETE
    ├── phase1_content_download.md
    ├── phase2_microsd_transfer.md  ← COMPLETE — 229GB on card
    ├── phase3_app_config.md
    ├── phase4_validation.md
    └── phase5_lockdown.md
```

---

## Comparison: BunkerAI BOB vs. This Build

| Category | BOB (BunkerAI.io, $799) | RT7 Alaska Build (~$450) |
|---|---|---|
| Battery | ~6,000–8,000mAh | 32,000mAh — 4–5x capacity |
| Ruggedness | Protective case, not rated | MIL-STD-810H / IP68/IP69K — submersible |
| AI Architecture | Proprietary, locked | Open: Phi-3 via ChatterUI (open source, no telemetry) |
| Night Vision | None | Built-in 20MP IR camera |
| Mesh Comms | None | Meshtastic LoRa + Briar Bluetooth |
| Flora/Fauna ID | None | Seek by iNaturalist (offline) |
| Model Updates | Vendor-dependent | User-controlled via Mac + ADB |
| Price | $799 | ~$450 |

---

## What Makes This "Alaska Edition"

- **ADFG regulations** — hunting, fishing, subsistence (GMU20 Interior Alaska specifically)
- **OsmAnd Alaska OBF** — full state OpenStreetMap data, roads, trails, waterways
- **USGS GeoPDF topos** — Interior Alaska quads at 1:63,000 scale (Fairbanks, Chena, Elliot Hwy, Steese, Richardson, Healy corridors)
- **Project Gutenberg Agriculture volume** — farming at Interior Alaska latitudes, food production without machinery
- **Outdoors Stack Exchange** — cold weather operations, wilderness survival, Interior Alaska conditions
- **FlexSolar 36W with MPPT** — 50% more wattage than original spec; MPPT optimizes harvest in partial shade; USB-C direct output; IP67 rated
- **Glove Mode** — enabled for operation with insulated gloves at -40°F

---

## Debloat — Completed via UAD-NG

Phase 0d debloat was completed using UAD-NG (Universal Android Debloater — Next Generation). Seven packages were removed including Oukitel bloatware and Google consumer apps. A "Deep Freeze" kill-chain was developed to defeat Oukitel's self-repair watcher services. Silent State achieved March 23, 2026.

The earlier manual ADB attempt (Phase 0b) caused a boot loop — recovered via PCB test point BROM entry and SP Flash Tool firmware reflash. Full incident log and UAD-NG operator guide in the repo.

Lawnchair Launcher replaced Nova as the permanent mission interface — open source, zero telemetry, Android 15 native. See [LAUNCHER_LAWNCHAIR.md](LAUNCHER_LAWNCHAIR.md).

Full debloat details: [DEBLOAT_OPERATIONS_LOG.md](DEBLOAT_OPERATIONS_LOG.md) | [UAD_NG_OPERATOR_GUIDE.md](UAD_NG_OPERATOR_GUIDE.md)

---

## Related Projects

- [Project NOMAD](https://projectnomad.us) — Desktop/server equivalent; Linux-based offline knowledge server. Complementary to this build (base camp server vs. field node).
- [Internet in a Box](https://internet-in-a-box.org/) — Lightweight Raspberry Pi alternative for basic offline content.

---

## License

This build documentation is released under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) — public domain. Use it, adapt it, build on it.

All referenced software is open source. See individual project licenses.

---

*Built in Fairbanks, Alaska. Designed for Interior Alaska grid-down operations.*
*Interior Alaska AO: Fairbanks / Fort Wainwright / Chena River drainage*
