<#
.SYNOPSIS
    Back up or restore IDE profile folders (Antigravity / Cursor / VS Code / Windsurf).

.PARAMETER Action      Backup | Restore. Default: Backup.
.PARAMETER Ide         Auto | Antigravity | Cursor | VSCode | Windsurf. Default: Auto (all).
.PARAMETER Names       Profile names to include. Default: Tropo, Strato, Meso, Exo.
.PARAMETER BackupDir   Where archives live. Default: %USERPROFILE%\IDEProfiles\Backups.
.PARAMETER KeepLast    Retention count on Backup. Default 5. Use 0 to keep all.
.PARAMETER From        On Restore, restore this specific .zip. Default: latest in $BackupDir.

.EXAMPLE
    .\backup.ps1
.EXAMPLE
    .\backup.ps1 -Action Restore
.EXAMPLE
    .\backup.ps1 -Ide Cursor -Names Work,Personal
#>
[CmdletBinding()]
param(
    [ValidateSet('Backup','Restore')] [string]$Action = 'Backup',
    [ValidateSet('Auto','Antigravity','Cursor','VSCode','Windsurf')] [string]$Ide = 'Auto',
    [string[]]$Names = @("Tropo","Strato","Meso","Exo"),
    [string]$BackupDir = "$env:USERPROFILE\IDEProfiles\Backups",
    [int]$KeepLast = 5,
    [string]$From
)

$ErrorActionPreference = 'Stop'

$prefixMap = [ordered]@{
    Antigravity = ".antigravity"
    Cursor      = ".cursor-profile"
    VSCode      = ".vscode-profile"
    Windsurf    = ".windsurf-profile"
}

function Get-ProfileFolders {
    $prefixes = if ($Ide -eq 'Auto') { $prefixMap.Values } else { @($prefixMap[$Ide]) }
    $found = @()
    foreach ($prefix in $prefixes) {
        foreach ($name in $Names) {
            $p = "$env:USERPROFILE\$prefix-$($name.ToLower())"
            if (Test-Path $p) { $found += $p }
        }
    }
    return $found
}

function Invoke-Backup {
    $folders = Get-ProfileFolders
    if (-not $folders) {
        Write-Host "[X] No profile folders found. Run scripts\setup.ps1 first." -ForegroundColor Red
        return
    }
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    $ts  = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $zip = Join-Path $BackupDir "Profiles_Backup_$ts.zip"
    Compress-Archive -Path $folders -DestinationPath $zip -Force
    $sizeMB = [math]::Round((Get-Item $zip).Length / 1MB, 2)
    Write-Host ""
    Write-Host "[OK] $zip ($sizeMB MB)" -ForegroundColor Green
    Write-Host "     Included: $($folders.Count) profile folder(s)" -ForegroundColor DarkGray

    if ($KeepLast -gt 0) {
        $stale = Get-ChildItem "$BackupDir\Profiles_Backup_*.zip" |
                 Sort-Object LastWriteTime -Descending |
                 Select-Object -Skip $KeepLast
        foreach ($f in $stale) {
            Remove-Item $f.FullName -Force
            Write-Host "     Pruned: $($f.Name)" -ForegroundColor DarkGray
        }
    }
}

function Invoke-Restore {
    if ($From) {
        if (-not (Test-Path $From)) { Write-Host "[X] Not found: $From" -ForegroundColor Red; return }
        $zip = Get-Item $From
    } else {
        $zip = Get-ChildItem "$BackupDir\*.zip" -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $zip) { Write-Host "[X] No backup found in $BackupDir" -ForegroundColor Red; return }
    }
    Write-Host "Restoring from: $($zip.FullName)"
    Expand-Archive -Path $zip.FullName -DestinationPath $env:USERPROFILE -Force
    Write-Host "[OK] Restore complete. Relaunch your shortcuts." -ForegroundColor Green
}

switch ($Action) {
    'Backup'  { Invoke-Backup }
    'Restore' { Invoke-Restore }
}
