<#
.SYNOPSIS
    Remove Multigrav shortcuts and (optionally) profile data.

.PARAMETER Ide         Auto | Antigravity | Cursor | VSCode | Windsurf. Default: Auto (all).
.PARAMETER Names       Profile names to remove. Default: Tropo, Strato, Meso, Exo.
.PARAMETER ShortcutsDir   Where shortcuts live. Default: %USERPROFILE%\IDEProfiles.
.PARAMETER RemoveProfiles Also delete profile folders (destructive, asks for confirmation).

.EXAMPLE
    .\uninstall.ps1
.EXAMPLE
    .\uninstall.ps1 -Ide Cursor -RemoveProfiles
#>
[CmdletBinding()]
param(
    [ValidateSet('Auto','Antigravity','Cursor','VSCode','Windsurf')] [string]$Ide = 'Auto',
    [string[]]$Names = @("Tropo","Strato","Meso","Exo"),
    [string]$ShortcutsDir = "$env:USERPROFILE\IDEProfiles",
    [switch]$RemoveProfiles
)

$ErrorActionPreference = 'Stop'

$ideMap = [ordered]@{
    Antigravity = @{ Prefix = ".antigravity";      Display = "Antigravity" }
    Cursor      = @{ Prefix = ".cursor-profile";   Display = "Cursor" }
    VSCode      = @{ Prefix = ".vscode-profile";   Display = "VS Code" }
    Windsurf    = @{ Prefix = ".windsurf-profile"; Display = "Windsurf" }
}

$targets = if ($Ide -eq 'Auto') { $ideMap.Values } else { @($ideMap[$Ide]) }

foreach ($t in $targets) {
    foreach ($name in $Names) {
        $lnk = "$ShortcutsDir\$($t.Display) $name.lnk"
        if (Test-Path $lnk) {
            Remove-Item $lnk -Force
            Write-Host "Removed shortcut: $lnk"
        }
    }
}

if ($RemoveProfiles) {
    Write-Host ""
    Write-Host "About to PERMANENTLY DELETE profile data for:" -ForegroundColor Yellow
    $deletable = @()
    foreach ($t in $targets) {
        foreach ($name in $Names) {
            $p = "$env:USERPROFILE\$($t.Prefix)-$($name.ToLower())"
            if (Test-Path $p) { Write-Host "  $p" -ForegroundColor Yellow; $deletable += $p }
        }
    }
    if (-not $deletable) { Write-Host "  (nothing to delete)" -ForegroundColor DarkGray; return }

    Write-Host ""
    $confirm = Read-Host "Type DELETE to confirm"
    if ($confirm -cne 'DELETE') {
        Write-Host "Cancelled. Profile data kept." -ForegroundColor Cyan
        return
    }
    foreach ($p in $deletable) {
        Remove-Item $p -Recurse -Force
        Write-Host "Removed: $p"
    }
}

Write-Host ""
Write-Host "Done." -ForegroundColor Cyan
