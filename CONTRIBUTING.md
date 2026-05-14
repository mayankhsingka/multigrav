# Contributing to Multigrav

Thanks for considering a contribution!

## Setup

No build step — the scripts run directly from `scripts/`.

```powershell
git clone https://github.com/mayankhsingka/multigrav
cd multigrav
.\scripts\setup.ps1 -Names TestA,TestB
```

## Testing your change

There's no automated test suite. Please verify manually:

- Run `setup.ps1` with at least two `-Names` and confirm profile folders + shortcuts appear under `%USERPROFILE%\IDEProfiles\`.
- Open one of the shortcuts and confirm the title bar got its color.
- Run `backup.ps1` then `uninstall.ps1 -RemoveProfiles` and confirm everything cleans up.
- Test against at least one IDE (Antigravity / Cursor / VS Code / Windsurf) if your change is multi-IDE-related.

Always test on fresh names (e.g. `-Names DevTestA,DevTestB`) so you don't clobber your real profiles while iterating.

## Style

- PowerShell 5.1 syntax (the default Windows shell — no `pwsh` 7+ features).
- ASCII output (`[OK]`, `[X]`, `[+]` markers — avoid emojis inside scripts; some consoles render them as `?`).
- Comment-based help (`<# .SYNOPSIS ... #>`) on every script.
- Match existing parameter conventions (`-Ide`, `-Names`, `-ExePath`, etc.).

## Submitting

1. Fork, branch from `main`.
2. Make your change.
3. Add an `## [Unreleased]` section to `CHANGELOG.md` describing it.
4. Open a PR with a clear description. For UX-facing changes, include a before/after.
