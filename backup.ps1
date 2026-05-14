# ============================================================
#  Antigravity Profile Backup & Restore Script
#  Backs up all 4 profile folders into a single zip
# ============================================================

$names = @("Tropo", "Strato", "Meso", "Exo")
$backupDir = "$env:USERPROFILE\Antig\Backups"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

function Backup {
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    $zipPath = "$backupDir\Antigravity_Backup_$timestamp.zip"

    $folders = $names | ForEach-Object { 
        "$env:USERPROFILE\.antigravity-$($_.ToLower())" 
    } | Where-Object { Test-Path $_ }

    if (-not $folders) { Write-Host "❌ No profile folders found to backup."; return }

    Compress-Archive -Path $folders -DestinationPath $zipPath -Force
    Write-Host "`n✅ Backup saved to: $zipPath"
    Write-Host "📦 Size: $([math]::Round((Get-Item $zipPath).Length / 1MB, 2)) MB"
}

function Restore {
    $latest = Get-ChildItem "$backupDir\*.zip" -ErrorAction SilentlyContinue | 
              Sort-Object LastWriteTime -Descending | 
              Select-Object -First 1

    if (-not $latest) { Write-Host "❌ No backup found in $backupDir"; return }

    Write-Host "📂 Restoring from: $($latest.Name)"
    Expand-Archive -Path $latest.FullName -DestinationPath "$env:USERPROFILE" -Force
    Write-Host "✅ Restored successfully! Relaunch your Antigravity shortcuts."
}

# ── Change to "Restore" when you need to restore ──
Backup
