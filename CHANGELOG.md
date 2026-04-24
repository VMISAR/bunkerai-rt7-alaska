# Changelog

All notable public documentation changes for the BunkerAI-RT7 Alaska Edition are recorded here.

This changelog is for repository documentation and build-state tracking. It does not replace `BUILD_LOG.md`, which remains the detailed technical build narrative.

## [2026-04-24] Phase 3 Documentation Update

### Added

- Completed Phase 3 (App Configuration) documentation in BUILD_LOG.md with actual results.
- Documented RT7 firmware quirks (SD card mount path, ADB install block, broken WallpaperPicker, BROM entry).
- Added AI benchmark results to README.md (Phi-3 Mini, 86s laceration query).
- Added Fossify Gallery wallpaper workaround to BUILD_LOG.md.

### Changed

- Updated README.md, BUILD_LOG.md, OPERATORS_CARD.md, and TROUBLESHOOTING.md to reflect Phase 3 completion.
- Replaced all Layla references with ChatterUI throughout.
- Replaced all Nova Launcher references with Lawnchair throughout.
- Corrected SD card paths from /sdcard/ to /storage/69C4-815C/ throughout.
- Corrected Phase 0c recovery narrative from placeholder to actual PCB test point + mtkclient path.
- Updated build status table: Phase 3 complete, Phase 4 partial.
- Updated OPERATORS_CARD.md to v1.1.
- Updated TROUBLESHOOTING.md with RT7 firmware quirks table and corrected recovery steps.

## Unreleased

### Added

- Added `.gitignore` to prevent macOS metadata, temporary files, local environment files, and private folders from being committed.
- Added `CONTENT_MANIFEST.md` to track offline content sources, locations, versions, checksums, and validation status.
- Added `VALIDATION_CHECKLIST.md` to define field-readiness validation standards.
- Added `MAINTENANCE_SCHEDULE.md` to define recurring upkeep, refresh cycles, and update freeze rules.
- Added public repository privacy notice to `README.md`.

### Changed

- Reframed commercial comparison language in `README.md` to make the claim more defensible and reproducible.
- Sanitized public build documentation to remove device-specific serial information and private local firmware path details.

### Removed

- Removed committed `.DS_Store` macOS metadata file.