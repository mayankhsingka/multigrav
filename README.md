# 🌌 Antigravity Multi-Profile

Run multiple **Antigravity IDE** accounts simultaneously on Windows — each fully isolated with its own login, extensions, and settings.

> Built for power users running multiple Pro accounts side by side.

---

## ✨ What This Does

- Creates **4 completely isolated Antigravity instances** on the same Windows machine
- Each instance has its own login session, extensions, and settings
- Named after atmospheric layers: **Tropo · Strato · Meso · Exo**
- Includes distinct color themes per instance so you always know which is which
- Includes a backup & restore script for your profiles

---

## 🚀 Quick Start

### Step 1 — Run the setup script

Open **PowerShell as Administrator** (`Win + S` → PowerShell → Right click → Run as Administrator)

```powershell
# Clone the repo or just download setup.ps1
.\scripts\setup.ps1
```

> ⚠️ If your Antigravity is installed at a different path, update line 5 in `setup.ps1`:
> ```powershell
> $ag = "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe"
> ```
> Run this to find your exact path:
> ```powershell
> Get-ChildItem -Path "$env:LOCALAPPDATA", "$env:PROGRAMFILES" -Recurse -Filter "Antigravity.exe" -ErrorAction SilentlyContinue | Select-Object FullName
> ```

### Step 2 — Launch your instances

Open `C:\Users\YOUR_USERNAME\Antig\` — you'll find 4 shortcuts:

| Shortcut | Profile Folder |
|---|---|
| Antigravity Tropo | `.antigravity-tropo` |
| Antigravity Strato | `.antigravity-strato` |
| Antigravity Meso | `.antigravity-meso` |
| Antigravity Exo | `.antigravity-exo` |

Launch each and sign into a different account.

### Step 3 — Apply color themes

So you can instantly tell instances apart in the taskbar:

1. Open each instance
2. Hit `Ctrl + Shift + P` → type **Open User Settings (JSON)**
3. Paste the contents of the matching file from the `themes/` folder
4. Save — title bar changes instantly, no restart needed

| Instance | Color | Theme File |
|---|---|---|
| Tropo | 🔵 Deep Ocean Blue | `themes/tropo-settings.json` |
| Strato | 🟤 Dark Amber | `themes/strato-settings.json` |
| Meso | 🟣 Deep Purple | `themes/meso-settings.json` |
| Exo | 🟢 Matrix Green | `themes/exo-settings.json` |

### Step 4 — Separate taskbar windows

By default Windows groups all instances under one icon. To see them separately:

Right click Taskbar → **Taskbar Settings** → **Combine taskbar buttons** → set to **Never**

Now each instance shows as a separate entry labeled by its open folder/file.

---

## 💾 Backup & Restore

Your login sessions and settings live in the profile folders. Back them up occasionally:

```powershell
# Backup all 4 profiles into a single zip
.\scripts\backup.ps1
```

Backup is saved to `C:\Users\YOUR_USERNAME\Antig\Backups\`

To restore, open `backup.ps1` and change the last line from `Backup` to `Restore`, then run it.

---

## 📁 Repo Structure

```
antigravity-multiprofile/
├── scripts/
│   ├── setup.ps1        # Creates 4 isolated profiles + shortcuts
│   └── backup.ps1       # Backup & restore all profiles
├── themes/
│   ├── tropo-settings.json
│   ├── strato-settings.json
│   ├── meso-settings.json
│   └── exo-settings.json
└── README.md
```

---

## 🧠 How It Works

Antigravity (like all VS Code forks) stores everything about a session — login, extensions, settings — in a single folder. The `--user-data-dir` flag redirects where that folder is.

```
Antigravity.exe --user-data-dir="C:\Users\YOU\.antigravity-tropo"
```

By pointing 4 instances at 4 different folders, they become completely independent. This is a built-in VS Code feature, not a hack.

---

## ⚠️ Things to Know

- **RAM usage** — Each Electron instance uses ~300MB–1GB RAM. 4 instances = 2–4GB. Keep an eye on your memory.
- **Shortcuts are just launchers** — If you delete a shortcut, your profile data is safe. Recreate shortcuts anytime with `setup.ps1`.
- **Profile folders are what matter** — Back these up if you care about your sessions and settings.
- **Works on same PC only** — Shortcuts hardcode the path to `Antigravity.exe`. On a new PC, reinstall Antigravity and rerun `setup.ps1`.

---

## 🤝 Contributing

Works for Cursor and other VS Code forks too — same `--user-data-dir` trick applies. PRs welcome!

---

## 📄 License

MIT
