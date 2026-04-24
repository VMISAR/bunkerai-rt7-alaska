# Changelog

All notable public documentation changes for the BunkerAI-RT7 Alaska Edition are recorded here.

This changelog is for repository documentation and build-state tracking. It does not replace `BUILD_LOG.md`, which remains the detailed technical build narrative.

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