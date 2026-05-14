# ============================================================
#  Antigravity Multi-Profile Setup Script
#  Creates 4 isolated Antigravity instances on Windows
#  Profiles: Tropo | Strato | Meso | Exo
# ============================================================

$ag = "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe"

# Verify Antigravity is installed
if (-not (Test-Path $ag)) {
    Write-Host "❌ Antigravity.exe not found at: $ag"
    Write-Host "   Please update the path in this script to match your installation."
    exit
}

$wsh = New-Object -ComObject WScript.Shell
$names = @("Tropo", "Strato", "Meso", "Exo")

# ── Clean up old Acc1-4 shortcuts from both Desktop locations ──
$desktops = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\OneDrive\Desktop"
)

foreach ($desktop in $desktops) {
    1..4 | ForEach-Object {
        $old = "$desktop\Antigravity Acc$_.lnk"
        if (Test-Path $old) { Remove-Item $old -Force; Write-Host "🗑️  Deleted old shortcut: $old" }
    }
}

# ── Clean up old profile folders ──
1..4 | ForEach-Object {
    $oldFolder = "$env:USERPROFILE\.antigravity-acc$_"
    if (Test-Path $oldFolder) { Remove-Item $oldFolder -Recurse -Force; Write-Host "🗑️  Deleted old profile: $oldFolder" }
}

# ── Create Antig shortcuts folder ──
$antig = "$env:USERPROFILE\Antig"
New-Item -ItemType Directory -Force -Path $antig | Out-Null
Write-Host "`n📁 Shortcuts folder: $antig"

# ── Create 4 isolated profiles + shortcuts ──
foreach ($name in $names) {
    $profileDir = "$env:USERPROFILE\.antigravity-$($name.ToLower())"
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    New-Item -ItemType Directory -Force -Path "$profileDir\extensions" | Out-Null

    $s = $wsh.CreateShortcut("$antig\Antigravity $name.lnk")
    $s.TargetPath = $ag
    $s.Arguments = "--user-data-dir=`"$profileDir`" --extensions-dir=`"$profileDir\extensions`""
    $s.IconLocation = $ag
    $s.Save()

    Write-Host "✅ Created: Antigravity $name  →  $profileDir"
}

Write-Host "`n🚀 Done! Open your shortcuts from: $antig"
Write-Host "   Sign into a different account in each instance.`n"
