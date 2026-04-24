# Maintenance Schedule

This schedule defines the recurring maintenance rhythm for the BunkerAI-RT7 Alaska Edition.

The goal is to keep the system reliable, current, and field-ready without constantly changing a stable offline build.

## Maintenance Principles

- Stability matters more than novelty.
- Do not update apps, models, maps, or content immediately before field use unless the update fixes a known problem.
- Refresh legal, regulatory, medical, and map content on a deliberate cycle.
- Validate after every meaningful change.
- Record changes in `BUILD_LOG.md` or a future changelog before considering the build current.
- Keep the RT7 usable offline. Avoid updates that introduce account, cloud, or network dependencies.

## Before Every Field Use

| Task | Status | Notes |
|---|---|---|
| Charge RT7 battery to field-ready level |  |  |
| Confirm MicroSD card mounts |  |  |
| Open Kiwix and test one ZIM file |  |  |
| Open OsmAnd and verify Alaska map loads |  |  |
| Open ChatterUI and test primary AI model |  |  |
| Open First Aid / medical reference |  |  |
| Confirm airplane mode behavior |  |  |
| Confirm operator card is available offline |  |  |
| Confirm field case contents |  |  |

## Monthly

| Task | Status | Notes |
|---|---|---|
| Boot RT7 and check for corruption warnings |  |  |
| Reboot and confirm launcher stability |  |  |
| Confirm MicroSD card readability |  |  |
| Spot-check three large files from MicroSD |  |  |
| Test AI model load and response |  |  |
| Test Kiwix search |  |  |
| Test map display |  |  |
| Review known limitations |  |  |

## Quarterly

| Task | Status | Notes |
|---|---|---|
| Review app/APK update needs |  |  |
| Refresh OsmAnd maps if needed |  |  |
| Review Kiwix library updates |  |  |
| Review medical content updates |  |  |
| Review AI model performance and replacement candidates |  |  |
| Update `CONTENT_MANIFEST.md` |  |  |
| Run `VALIDATION_CHECKLIST.md` for changed components |  |  |

## Annually

| Task | Status | Notes |
|---|---|---|
| Refresh Alaska hunting regulations |  |  |
| Refresh Alaska fishing regulations |  |  |
| Refresh subsistence regulations |  |  |
| Review USGS topo coverage for intended AO |  |  |
| Review field hardware and solar charging setup |  |  |
| Re-run full validation checklist |  |  |
| Review public repo for sensitive data exposure |  |  |
| Archive old manifest/version notes if needed |  |  |

## After Any Major Change

Examples of major changes include replacing the MicroSD card, changing launchers, updating the AI model, adding large content libraries, changing recovery tools, or installing/removing major apps.

| Task | Status | Notes |
|---|---|---|
| Record what changed |  |  |
| Record why it changed |  |  |
| Update content manifest if files changed |  |  |
| Update validation checklist results |  |  |
| Reboot RT7 |  |  |
| Test affected apps offline |  |  |
| Confirm no account/cloud dependency was introduced |  |  |
| Confirm public documentation remains sanitized |  |  |

## Update Freeze Rule

Do not make non-critical changes within 72 hours of planned field use.

During the freeze window, only fix issues that would prevent the tablet from performing its mission.

## Version Snapshot Template

Use this template when recording a periodic maintenance snapshot:

```text
Date:
Maintainer:
RT7 status:
MicroSD status:
Apps changed:
Content changed:
AI models changed:
Maps changed:
Validation performed:
Known issues:
Next action:
```

