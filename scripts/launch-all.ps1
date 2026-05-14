<#
.SYNOPSIS
    Launch every shortcut in the IDEProfiles folder at once.

.PARAMETER ShortcutsDir   Where shortcuts live. Default: %USERPROFILE%\IDEProfiles.
.PARAMETER Filter         Glob to match. Default: *.lnk (everything).

.EXAMPLE
    .\launch-all.ps1
.EXAMPLE
    .\launch-all.ps1 -Filter "Cursor *.lnk"
#>
[CmdletBinding()]
param(
    [string]$ShortcutsDir = "$env:USERPROFILE\IDEProfiles",
    [string]$Filter = "*.lnk"
)

$shortcuts = Get-ChildItem -Path $ShortcutsDir -Filter $Filter -ErrorAction SilentlyContinue
if (-not $shortcuts) {
    Write-Host "[X] No shortcuts in $ShortcutsDir (filter: $Filter). Run setup.ps1 first." -ForegroundColor Red
    return
}
foreach ($s in $shortcuts) {
    Start-Process $s.FullName
    Write-Host "Launched: $($s.BaseName)" -ForegroundColor Green
}
