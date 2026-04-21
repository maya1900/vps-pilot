# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-04-21

### Added

- Added `ssh-config sync` for generating managed SSH host aliases
- Added `code <name> [path]` for opening remote directories in VS Code Remote-SSH
- Added `backup <name> <path>` for pre-edit remote backups
- Added `doctor <name> [service|container]` for diagnostics and optional AI analysis
- Added development design document at `docs/development-plan.md`

### Changed

- Refined CLI layout, menu ordering, and help output for a cleaner day-to-day workflow
- Upgraded `status` so single-host view shows a richer diagnostic panel
- Simplified the main menu to keep only the most frequently used commands

## [0.0.2] - 2026-04-21

### Added

- Added badges and screenshot assets to README
- Added three-step quick start guide
- Added `ROADMAP.md` for next version planning
- Added Windows wrapper usage documentation

### Changed

- Refined project README structure for a more formal release style
- Updated project version metadata to `v0.0.2`

## [0.0.1] - 2026-04-21

### Added

- Initial release of `VPS Pilot`
- Multi-server configuration via `servers.conf`
- Server list, SSH login, status check, health check, batch command session
- Container listing and container batch command session
- Parallel execution support for selected commands
- Configuration validation
- SSH key distribution with deduplication
- Interactive menu mode
- Windows wrappers: `vps.cmd` and `vps.ps1`
- `MIT License`
