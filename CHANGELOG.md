# Changelog


## 0.1.0 - 2026-08-06

Initial public development release.

### Added

- Process ranking by resident memory usage.
- Sorting by RSS or memory percentage.
- User and PID filtering.
- Minimum RSS filtering.
- Human-readable RSS units.
- JSON output.
- CSV output.
- Watch mode.
- Snapshot logging.
- Summary output.
- Manual page.
- Bash completion.
- User-local Makefile installation.
- `-V` and `--version` version reporting.

### Changed

- Improved terminal color portability.
- Added automatic terminal color detection.
- Disabled automatic ANSI color for redirected output.
- Added `NO_COLOR` support.
- Improved behavior on terminals with limited color capability.

### Fixed

- Rejected zero-second watch intervals.
- Avoided unconditional screen clearing when output is not an interactive
  terminal.

All notable changes to this project should be documented here.

The project currently tracks unreleased work on the default branch.

## Unreleased

### Added

- Complete project README.
- Makefile installation and removal targets.
- Manual page for `man memtop`.
- User-local Bash completion.
- Smoke tests for CLI behavior and output formats.
- GitHub Actions CI.
- Contribution and security documentation.
- Manual-page diagnostic helper.

### Planned

- Stable version option.
- First tagged release.
- Release archive and SHA-256 checksums.
- Additional edge-case and regression tests.
