# BunkerAI-RT7 Alaska Edition

**A fully self-contained, air-gapped survival intelligence terminal built on the Oukitel RT7 Titan 5G**

> *Zero-Dark-Access | Open Architecture | Alaska-Hardened*

---

## What This Is

This is a complete build log documenting how to turn an Oukitel RT7 Titan 5G rugged tablet into a fully offline survival intelligence terminal — no internet, no cellular, no cloud. Everything runs from a SanDisk Extreme MicroSD card loaded with AI models, offline knowledge libraries, topographic maps, and communications tools.

The design baseline was the commercial [BunkerAI "BOB" tablet](https://bunkerai.io/) ($799). This build exceeds it in every category that matters — battery life, ruggedness, AI capability, and open architecture — at roughly half the cost.

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
│           NOVA LAUNCHER DASHBOARD            │
│     (Mission computer UI — one screen)       │
├──────────────┬──────────────────────────────┤
│ AI LAYER     │ Layla + Phi-3 Mini GGUF       │
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

**Total staged: ~244GB of ~476GB usable (~51%). ~232GB headroom remaining.**

---

## Build Status

| Phase | Status | Notes |
|---|---|---|
| Phase 0 — Hardware Acquisition | ✅ Complete | RT7 in hand |
| Phase 0b — Debloat | ⚠️ Learned hard lesson | Boot loop — do not debloat (see TROUBLESHOOTING.md) |
| Phase 0c — Firmware Recovery | ✅ Resolved | Device reflashed to clean Android 15 baseline |
| Phase 1 — Content Download | ✅ Complete | 244GB staged across two drives |
| Phase 2 — MicroSD Transfer | 🔄 In Progress | Waiting on SanDisk Extreme 512GB arrival |
| Phase 3 — App Configuration | ⏳ Pending | |
| Phase 4 — Validation | ⏳ Pending | |
| Phase 5 — Final Lockdown | ⏳ Pending | |

---

## Hardware Bill of Materials

| Item | Detail | Notes |
|---|---|---|
| Oukitel RT7 Titan 5G | Primary device | ~$400 |
| SanDisk Extreme 512GB MicroSD (V30/U3) | Content storage | **Must be V30/U3** — Ultra Plus not acceptable |
| Anker 24W CIGS Flexible Solar Panel | Off-grid charging | CIGS outperforms mono-crystalline in low-light/overcast |
| Anker PowerLine III Flow USB-C (10ft) | Data transfer + solar charge | 100W rated |
| Pelican 1450 Protector Case | Transport + storage | Custom Pick-N-Pluck foam |

---

## Repository Structure

```
bunkerai-rt7-alaska/
├── README.md                   ← You are here
├── BUILD_LOG.md                ← Full narrative build log (all phases)
├── HARDWARE.md                 ← BOM, specs, sourcing decisions
├── SOFTWARE.md                 ← Full app stack + configuration reference
├── CONTENT.md                  ← Complete ZIM library + transfer commands
├── TROUBLESHOOTING.md          ← The boot loop incident + lessons learned
├── OPERATORS_CARD.md           ← One-page quick reference for field use
└── phases/
    ├── phase0_first_boot.md
    ├── phase0b_debloat.md      ← What went wrong and why
    ├── phase0c_recovery.md     ← 9 recovery attempts, firmware reflash
    ├── phase1_content_download.md
    ├── phase2_microsd_transfer.md   ← IN PROGRESS
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
| AI Architecture | Proprietary, locked | Open: Phi-3 via Layla / MLC LLM |
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
- **CIGS solar panel selection** — specifically chosen for diffuse winter sun performance in Fairbanks area
- **Glove Mode** — enabled for operation with insulated gloves at -40°F

---

## Important: Do Not Debloat

The biggest lesson from this build: **do not attempt ADB debloat on the RT7 Titan.**

Removing `com.android.nfc` and certain system packages on the MT6853 / Android 15 EEA build causes a boot loop that cannot be fixed without Windows + SP Flash Tool or PCB test point access. The device will show "corrupted software — press power to boot" on every subsequent boot with no path to recovery from macOS alone.

Full incident log: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

The build works without debloat. The Nova Launcher kiosk configuration achieves the same clean interface without touching the system partition.

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
