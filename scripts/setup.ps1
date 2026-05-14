<#
.SYNOPSIS
    Create isolated multi-account profiles for Antigravity / Cursor / VS Code / Windsurf on Windows.

.DESCRIPTION
    Auto-detects the installed IDE, then for each profile name creates an isolated
    user-data + extensions directory, writes a color-coded settings.json, and
    generates a shortcut. No admin needed - everything under %USERPROFILE%.

    Profiles : %USERPROFILE%\.<ide>-<name>\
    Shortcuts: %USERPROFILE%\IDEProfiles\

.PARAMETER Ide
    Antigravity, Cursor, VSCode, Windsurf, or Auto. Auto picks the first
    installed IDE in that priority order. Default: Auto.

.PARAMETER Names
    Profile names to create. Default: Tropo, Strato, Meso, Exo.

.PARAMETER ExePath
    Full path to the IDE .exe. Bypasses auto-detection; works for any
    VS Code fork even if not in the built-in registry.

.PARAMETER ShortcutsDir
    Where to place the .lnk files. Default: %USERPROFILE%\IDEProfiles.

.PARAMETER SkipThemes
    Don't write color themes into each profile's settings.json.

.EXAMPLE
    .\setup.ps1
    Detect installed IDE; create Tropo / Strato / Meso / Exo.

.EXAMPLE
    .\setup.ps1 -Ide Cursor -Names Work,Personal,Client

.EXAMPLE
    .\setup.ps1 -ExePath "D:\Tools\MyFork\Fork.exe"
#>
[CmdletBinding()]
param(
    [ValidateSet('Auto','Antigravity','Cursor','VSCode','Windsurf')]
    [string]$Ide = 'Auto',
    [string[]]$Names = @("Tropo","Strato","Meso","Exo"),
    [string]$ExePath,
    [string]$ShortcutsDir = "$env:USERPROFILE\IDEProfiles",
    [switch]$SkipThemes
)

$ErrorActionPreference = 'Stop'

$ideRegistry = [ordered]@{
    Antigravity = @{
        Exe = "Antigravity.exe"
        Paths = @("$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe")
        Prefix = ".antigravity"
        Display = "Antigravity"
    }
    Cursor = @{
        Exe = "Cursor.exe"
        Paths = @(
            "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
            "$env:LOCALAPPDATA\Programs\Cursor\Cursor.exe"
        )
        Prefix = ".cursor-profile"
        Display = "Cursor"
    }
    VSCode = @{
        Exe = "Code.exe"
        Paths = @(
            "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
            "$env:ProgramFiles\Microsoft VS Code\Code.exe"
        )
        Prefix = ".vscode-profile"
        Display = "VS Code"
    }
    Windsurf = @{
        Exe = "Windsurf.exe"
        Paths = @("$env:LOCALAPPDATA\Programs\Windsurf\Windsurf.exe")
        Prefix = ".windsurf-profile"
        Display = "Windsurf"
    }
}

$themes = @{
    Tropo  = @{ active = "#003566"; inactive = "#002244"; fg = "#ffffff" } # Deep Ocean Blue
    Strato = @{ active = "#3b1f00"; inactive = "#2a1500"; fg = "#ffffff" } # Dark Amber
    Meso   = @{ active = "#1a0033"; inactive = "#110022"; fg = "#ffffff" } # Deep Purple
    Exo    = @{ active = "#001a00"; inactive = "#001200"; fg = "#00ff41" } # Matrix Green
}
$fallback = @(
    @{ active = "#1f1f1f"; inactive = "#161616"; fg = "#ffffff" },
    @{ active = "#3d0000"; inactive = "#2a0000"; fg = "#ffffff" },
    @{ active = "#003d3d"; inactive = "#002a2a"; fg = "#ffffff" },
    @{ active = "#2a003d"; inactive = "#1a002a"; fg = "#ffffff" }
)

function Find-IdeExe {
    param([string]$Choice)
    $order = if ($Choice -eq 'Auto') { @($ideRegistry.Keys) } else { @($Choice) }
    foreach ($k in $order) {
        foreach ($p in $ideRegistry[$k].Paths) {
            if (Test-Path $p) { return $p }
        }
    }
    return $null
}

function Resolve-Ide {
    param([string]$Choice, [string]$Path)

    if (-not $Path) { $Path = Find-IdeExe -Choice $Choice }

    if (-not $Path) {
        try {
            Add-Type -AssemblyName System.Windows.Forms
            $dlg = New-Object System.Windows.Forms.OpenFileDialog
            $dlg.Title = "Locate your IDE (Antigravity.exe / Cursor.exe / Code.exe / Windsurf.exe)"
            $dlg.Filter = "Executable (*.exe)|*.exe"
            $dlg.InitialDirectory = "$env:LOCALAPPDATA\Programs"
            if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { $Path = $dlg.FileName }
        } catch { }
    }
    if (-not $Path -or -not (Test-Path $Path)) { return $null }

    $exeName = [IO.Path]::GetFileName($Path)
    foreach ($k in $ideRegistry.Keys) {
        if ($ideRegistry[$k].Exe -ieq $exeName) {
            return @{ Key = $k; Info = $ideRegistry[$k]; ExePath = $Path }
        }
    }
    $stem = [IO.Path]::GetFileNameWithoutExtension($exeName)
    return @{
        Key = 'Custom'
        Info = @{ Exe = $exeName; Prefix = ".$($stem.ToLower())-profile"; Display = $stem }
        ExePath = $Path
    }
}

$ide = Resolve-Ide -Choice $Ide -Path $ExePath
if (-not $ide) {
    Write-Host "[X] No IDE found. Install Antigravity / Cursor / VS Code / Windsurf, or pass -ExePath." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "IDE        : $($ide.Info.Display)" -ForegroundColor Cyan
Write-Host "Executable : $($ide.ExePath)"      -ForegroundColor Cyan
Write-Host "Shortcuts  : $ShortcutsDir"        -ForegroundColor Cyan
Write-Host "Profiles   : $($Names -join ', ')" -ForegroundColor Cyan
Write-Host ""

New-Item -ItemType Directory -Force -Path $ShortcutsDir | Out-Null
$wsh = New-Object -ComObject WScript.Shell
$idx = 0

foreach ($name in $Names) {
    $slug = $name.ToLower()
    $profileDir = "$env:USERPROFILE\$($ide.Info.Prefix)-$slug"
    $extDir     = "$profileDir\extensions"
    $userDir    = "$profileDir\User"

    New-Item -ItemType Directory -Force -Path $profileDir, $extDir, $userDir | Out-Null

    if (-not $SkipThemes) {
        $settingsPath = "$userDir\settings.json"
        if (-not (Test-Path $settingsPath)) {
            $t = if ($themes.ContainsKey($name)) { $themes[$name] } else { $fallback[$idx % $fallback.Count] }
            $obj = [pscustomobject]@{
                "workbench.colorCustomizations" = [ordered]@{
                    "titleBar.activeBackground"   = $t.active
                    "titleBar.activeForeground"   = $t.fg
                    "titleBar.inactiveBackground" = $t.inactive
                }
            }
            Set-Content -Path $settingsPath -Value ($obj | ConvertTo-Json -Depth 5) -Encoding UTF8
        }
    }

    $lnk = "$ShortcutsDir\$($ide.Info.Display) $name.lnk"
    $s = $wsh.CreateShortcut($lnk)
    $s.TargetPath   = $ide.ExePath
    $s.Arguments    = "--user-data-dir=`"$profileDir`" --extensions-dir=`"$extDir`""
    $s.IconLocation = $ide.ExePath
    $s.Save()

    Write-Host ("  [+] {0,-12} -> {1}" -f $name, $profileDir) -ForegroundColor Green
    $idx++
}

Write-Host ""
Write-Host "Done. Open $ShortcutsDir and launch each shortcut." -ForegroundColor Cyan
Write-Host "Sign into a different account in each window." -ForegroundColor Cyan
