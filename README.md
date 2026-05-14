# 🌌 Multigrav — Multiple Antigravity Accounts on Windows

**Run 4 isolated Antigravity IDE accounts side-by-side on the same machine** — each with its own login, extensions, settings, and a color-coded title bar so you never confuse windows.

Built for power users juggling multiple Antigravity Pro subscriptions.

One PowerShell command. No admin. No installer. No patching.

> _💡 Demo GIF coming soon — 4-window side-by-side capture._

---

## ✨ Why?

- **Multiple Antigravity Pro accounts** — sign into 4 (or more) accounts at the same time. Work + personal + clients, all running in parallel.
- **Hard isolation** — extensions, settings, history, and logins never bleed between profiles.
- **Visual separation** — unique title-bar color per profile so the right window is obvious in the taskbar.
- **One command** — no admin, no registry edits, no patching. Just PowerShell + a documented VS Code flag.

### Why not Antigravity's built-in Profiles?

Antigravity inherits VS Code Profiles, which swap *settings & extensions* inside a single login. Multigrav gives you *fully separate logins* — what built-in Profiles can't do. Use both together if you want.

---

## 🚀 Quick Start

Never touched PowerShell? No problem — this is a 3-step copy-paste.

### Step 1 — Get the code

Either:
- **Clone it:** `git clone https://github.com/mayankhsingka/multigrav.git` (then `cd multigrav`)
- **Or download the ZIP:** green **Code** button on GitHub → **Download ZIP** → unzip it → remember the folder.

### Step 2 — Open PowerShell *in that folder*

The simplest way: open the unzipped/cloned folder in File Explorer, then in the address bar at the top, type `powershell` and press Enter. A blue terminal will open *already inside that folder*.

(Or: `Win` key → type "PowerShell" → Enter → then `cd "C:\path\to\multigrav"`.)

### Step 3 — Run setup

Paste these two lines, one at a time, pressing Enter after each:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
.\scripts\setup.ps1
```

(The first line only needs to run once per machine — it lets PowerShell run unsigned scripts you've downloaded. It's a user-level setting, not admin-level.)

You should see output like:

```
IDE        : Cursor
Executable : C:\Users\you\AppData\Local\Programs\cursor\Cursor.exe
Shortcuts  : C:\Users\you\IDEProfiles
Profiles   : Tropo, Strato, Meso, Exo

  [+] Tropo        -> C:\Users\you\.cursor-profile-tropo
  [+] Strato       -> C:\Users\you\.cursor-profile-strato
  [+] Meso         -> C:\Users\you\.cursor-profile-meso
  [+] Exo          -> C:\Users\you\.cursor-profile-exo

Done. Open C:\Users\you\IDEProfiles and launch each shortcut.
```

The script auto-detects your Antigravity installation and creates 4 isolated profiles, each with a different title-bar color:

| Profile | Color |
|---|---|
| Tropo | 🔵 Deep Ocean Blue |
| Strato | 🟤 Dark Amber |
| Meso | 🟣 Deep Purple |
| Exo | 🟢 Matrix Green |

### Step 4 — Open them

Open `%USERPROFILE%\IDEProfiles\` in File Explorer. You'll see 4 shortcuts. Double-click each one and sign in with a different account. That's it.

---

## 🛠 Customizing

```powershell
# Custom profile names (any number, any labels):
.\scripts\setup.ps1 -Names Work,Personal,Client

# Explicit Antigravity path (if auto-detect missed it):
.\scripts\setup.ps1 -ExePath "D:\Tools\Antigravity\Antigravity.exe"

# Skip auto-applied themes (set colors yourself):
.\scripts\setup.ps1 -SkipThemes

# Shortcuts on the Desktop:
.\scripts\setup.ps1 -ShortcutsDir "$env:USERPROFILE\Desktop"
```

Re-running `setup.ps1` is safe: existing `settings.json` files are not overwritten.

---

## ▶️ Launching

```powershell
.\scripts\launch-all.ps1                          # every profile
.\scripts\launch-all.ps1 -Filter "Antigravity *"  # only Antigravity profiles
```

Or double-click any shortcut in `%USERPROFILE%\IDEProfiles\`.

---

## 💾 Backup & Restore

```powershell
# Back up all profiles (keeps last 5 archives):
.\scripts\backup.ps1

# Restore latest:
.\scripts\backup.ps1 -Action Restore

# Restore a specific archive:
.\scripts\backup.ps1 -Action Restore -From "C:\path\to\Profiles_Backup_2026-05-14_12-00.zip"

# Back up only one IDE if you've set up several:
.\scripts\backup.ps1 -Ide Antigravity

# Keep everything forever:
.\scripts\backup.ps1 -KeepLast 0
```

Backups land in `%USERPROFILE%\IDEProfiles\Backups\`.

---

## 🧹 Uninstall

```powershell
# Remove shortcuts only (profile data kept):
.\scripts\uninstall.ps1

# Remove shortcuts AND profile data (prompts to confirm):
.\scripts\uninstall.ps1 -RemoveProfiles

# Limit to one IDE if you've set up several:
.\scripts\uninstall.ps1 -Ide Antigravity -RemoveProfiles
```

---

## 🪟 Taskbar Tip

By default Windows groups all instances under one icon. To see them separately:

> Right-click Taskbar → **Taskbar Settings** → **Combine taskbar buttons** → **Never**

---

## 🧠 How It Works

Each shortcut launches Antigravity with two first-class VS Code flags:

```
Antigravity.exe --user-data-dir="...\.antigravity-tropo" --extensions-dir="...\.antigravity-tropo\extensions"
```

- `--user-data-dir` isolates login, settings, history
- `--extensions-dir` isolates installed extensions

Antigravity inherits these from its VS Code base. Nothing is patched, hooked, or injected.

---

## 🧯 Troubleshooting

**"...cannot be loaded because running scripts is disabled on this system."**
Run once: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`

**"No IDE found"**
Pass the path explicitly:
```powershell
.\scripts\setup.ps1 -ExePath "C:\full\path\Antigravity.exe"
```
Or search for it:
```powershell
Get-ChildItem $env:LOCALAPPDATA, $env:ProgramFiles -Recurse -Filter Antigravity.exe -ErrorAction SilentlyContinue | Select-Object FullName
```

**Title-bar color didn't change**
In that profile, hit `Ctrl+Shift+P` → **Developer: Reload Window**. If still nothing, verify `%USERPROFILE%\.<ide>-profile-<name>\User\settings.json` exists.

**Windows SmartScreen warns about the .ps1**
Right-click the file → Properties → **Unblock**. Or just paste the script body into a PowerShell window — same effect.

**RAM usage**
Each Electron instance uses ~300MB–1GB. Four instances ≈ 2–4GB. Keep an eye on memory.

---

## 📁 Repo Structure

```
.
├── scripts/
│   ├── setup.ps1        # Multi-IDE setup: profiles + themed shortcuts
│   ├── backup.ps1       # Back up / restore profile data
│   ├── launch-all.ps1   # Open every profile at once
│   └── uninstall.ps1    # Remove shortcuts (and optionally profile data)
├── themes/              # Reference theme files (setup.ps1 applies them automatically)
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## 🧩 Also works with other VS Code forks

Multigrav is built for Antigravity, but the same scripts work with any other VS Code fork (Cursor, VS Code, Windsurf), since they all support the `--user-data-dir` flag:

```powershell
.\scripts\setup.ps1 -Ide Cursor      # or VSCode, or Windsurf
.\scripts\setup.ps1 -ExePath "<path-to-your-fork.exe>"
```

You'll get color-isolated profiles for those too. Not the focus of the project — but it's there if you need it.

---

## 🤝 Contributing

PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Please test on fresh profile names (`-Names TestA,TestB`) so you don't clobber your own profiles while iterating.

---

## 📄 License

[MIT](LICENSE)
