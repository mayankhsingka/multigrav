# Changelog

## [0.3.0] - 2026-05-14

### Added
- `.github/ISSUE_TEMPLATE/` (bug + feature), `.github/PULL_REQUEST_TEMPLATE.md`, `CONTRIBUTING.md`.
- Optional `-Ide` parameter to also drive Cursor, VS Code, or Windsurf with the same scripts (Antigravity remains the primary focus and default).

### Changed
- Default shortcuts directory: `%USERPROFILE%\IDEProfiles` (was `%USERPROFILE%\Antig`).
- Default backup directory: `%USERPROFILE%\IDEProfiles\Backups`.
- README repositioned around Antigravity as the first-class target.
- `-AntigravityPath` renamed to the more general `-ExePath`.

## [0.2.0] - 2026-05-14

### Added
- Auto-detection of the IDE executable (probes common paths, falls back to a file picker).
- `setup.ps1` parameters: `-Names`, `-ExePath`, `-ShortcutsDir`, `-SkipThemes`.
- Themes are written into each profile's `settings.json` automatically — no manual paste.
- `scripts/launch-all.ps1` — open every profile in one command.
- `scripts/uninstall.ps1` — remove shortcuts (optionally also delete profile data, with confirmation).
- `backup.ps1` parameters: `-Action Backup|Restore`, `-From`, `-KeepLast`, `-Names`, `-BackupDir`.
- Backup retention: keeps the last 5 archives by default.

### Changed
- Repo layout: scripts moved to `scripts/`, themes moved to `themes/`.
- No longer requires Administrator — every write is under `%USERPROFILE%`.
- README rewritten: troubleshooting, parameter docs, customization examples.
- Restore no longer requires editing the script — `backup.ps1 -Action Restore`.

### Removed
- Hard-coded path edit on `setup.ps1` line 5 (handled by auto-detect / `-ExePath`).
- The "run as Administrator" instruction (it was never actually required).

## [0.1.0]

- Initial release: 4 hard-coded Antigravity profiles, manual theme application, edit-the-script restore flow.
