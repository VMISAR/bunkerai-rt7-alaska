# BunkerAI-RT7 — Operator's Quick Reference

*Interior Alaska AO | Zero-Dark-Access*

---

## Device State

| | Default | Notes |
|---|---|---|
| Airplane Mode | **ON** | GPS still active |
| Bluetooth | OFF until needed | Enable for Meshtastic / Briar |
| Screen Brightness | 50% | Adjust for solar balance |
| Virtual RAM | 24GB | Set once — persists |

---

## App Quick Reference

| App | Function | Location |
|---|---|---|
| **Layla** | Ask the AI anything | Center tile |
| **Kiwix** | Search offline Wikipedia, Gutenberg, Army manuals, medical refs | Left column |
| **OsmAnd** | Offline GPS navigation | Left column |
| **Meshtastic** | LoRa mesh radio — long range | Left column |
| **Briar** | Bluetooth/WiFi messaging — close range | Right column |
| **First Aid IFRC** | Emergency medical procedures | Right column |
| **Seek** | Plant / animal identification | Bottom row |
| **IR Camera** | Night vision — passive observation | Bottom row |

---

## AI Query Examples

```
"I have a deep laceration, a first aid kit, no evac for 48 hours.
 Options for wound closure and infection prevention?"

"I found mushrooms matching [description]. Edible in Interior Alaska?"

"Vehicle won't start. [Symptoms]. Likely cause and field fix?"

"Signs of hypothermia. Treatment with sleeping bag and hand warmers only."
```

**AI does not retrieve stored text — it reasons through problems.**
**Cross-reference critical decisions with Kiwix medical references.**

---

## Kiwix — Key Libraries

| Library | Best For |
|---|---|
| Wikipedia | Anything general — start here |
| Army Publications | Field sanitation, shelter, land nav, field medicine |
| iFixit | Equipment repair with photos |
| Military Field Medicine | Trauma, austere environment care |
| MedlinePlus | Drug info, symptoms, treatments (plain language) |
| Outdoors Stack Exchange | Cold weather survival, wilderness operations |
| Gutenberg Agriculture | Farming, food production without machinery |
| CD3WD | Building from raw materials — no modern tools assumed |

---

## Comms Matrix

| Range | Tool | Requirement |
|---|---|---|
| ~1km+ | Meshtastic LoRa | Heltec V3 node paired |
| ~10–50m | Briar Bluetooth | Second Briar device paired |
| ~100m+ | Briar WiFi mesh | Both devices WiFi enabled |

All comms work in Airplane Mode. Enable Bluetooth when using Briar or pairing Meshtastic.

---

## Navigation

**OsmAnd loaded with:** Full Alaska OpenStreetMap (roads, trails, waterways)

**Priority coverage:** Fairbanks AO, Chena River drainage, Elliot Hwy, Steese Hwy, Richardson Hwy, Parks Hwy/Denali corridor

**USGS Topos:** `/sdcard/USGS_Topos/Interior_Alaska/` — open with any PDF viewer

> Alaska USGS topo quads are **1:63,000 scale** — not 1:24,000 as in the lower 48. This is standard for Alaska.

---

## Alaska Reference PDFs

Location: `/sdcard/BunkerAI/ADFG/`

| File | Contents |
|---|---|
| `alaska_hunting_regs_2025-2026.pdf` | Full statewide regs |
| `GMU20_interior_alaska_2025-2026.pdf` | **Your AO — start here** |
| `subsistence_fishing_regs_2025-2026.pdf` | Subsistence fishing |
| `subsistence_hunt_supplement_2025-2026.pdf` | Tier I/II/Community Harvest |

**Open with:** VLC or any PDF viewer on the RT7

---

## Foraging Warning

Seek by iNaturalist identifies species but **does not always flag Alaska-specific toxicity.**

**Before consuming any foraged plant:**
1. Seek → identify species
2. Cross-reference with ADFG Edible/Poisonous Plants PDF
3. Query Layla with the specific species name and your intended use
4. Check Wikipedia botany entry if uncertain

**When in doubt: do not eat it.**

---

## Power Management

| State | Battery Draw | Solar Balance |
|---|---|---|
| Active AI inference | High | Panel must be in direct/partial sun |
| Kiwix + navigation | Moderate | Partial sun sufficient |
| Comms only (Meshtastic) | Low | Most overcast conditions |
| Standby | Very low | Minimal panel needed |

**Solar test passed:** Record charge rate and conditions here: ________________

**Battery reserve target:** Keep above 20% — 32,000mAh provides significant buffer.

---

## MicroSD Content

| Folder | Contents |
|---|---|
| `/sdcard/Kiwix/` | All ZIM files |
| `/sdcard/AI_Models/` | Phi-3 Mini + Phi-3.5 Mini GGUF |
| `/sdcard/BunkerAI/ADFG/` | Alaska regulatory PDFs |
| `/sdcard/BunkerAI/CD3WD/` | Pre-industrial knowledge ISOs |
| `/sdcard/USGS_Topos/Interior_Alaska/` | GeoPDF topographic maps |
| `/sdcard/Android/data/net.osmand/files/` | Alaska OBF map data |

---

*BunkerAI-RT7 Alaska Edition v1.0*
*Zero-Dark-Access | Interior Alaska | Air-Gapped*
