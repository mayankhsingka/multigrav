# 🌌 Multigrav — Multiple Antigravity Accounts on Windows

**Run 4 isolated Antigravity IDE accounts side-by-side on the same machine** — each with its own login, extensions, settings, and a color-coded title bar so you never confuse windows.

Built for power users juggling multiple Antigravity Pro subscriptions.

One PowerShell command. No admin. No installer. No patching.

> _💡 Demo GIF coming soon — 4-window side-by-side capture._

---

## ⚡ 30-second pitch

- **Who it's for:** anyone running 2+ Antigravity Pro accounts on Windows (work + personal, multiple clients, etc.).
- **What it does:** one PowerShell command creates 4 isolated, color-coded Antigravity sessions you can run at the same time.
- **Why not just sign out and back in?** Because that wipes your editor state — open files, extensions, terminal history, signed-in extensions. Multigrav keeps each account fully self-contained. Switch by clicking, not by logging out.

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

Open the unzipped / cloned folder in File Explorer. **Click the address bar at the top, type `powershell`, and press Enter.** A blue terminal opens *already inside that folder* — no `cd` needed.

> _Alternate route: `Win` key → type "PowerShell" → Enter → then `cd "C:\path\to\multigrav"`._

### Step 3 — Run setup

Paste these two lines, one at a time, pressing Enter after each:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
.\scripts\setup.ps1
```

(The first line only needs to run once per machine — it lets PowerShell run unsigned scripts you've downloaded. It's a user-level setting, not admin-level.)

You should see output like:

```
IDE        : Antigravity
Executable : C:\Users\you\AppData\Local\Programs\Antigravity\Antigravity.exe
Shortcuts  : C:\Users\you\IDEProfiles
Profiles   : Tropo, Strato, Meso, Exo

  [+] Tropo        -> C:\Users\you\.antigravity-tropo
  [+] Strato       -> C:\Users\you\.antigravity-strato
  [+] Meso         -> C:\Users\you\.antigravity-meso
  [+] Exo          -> C:\Users\you\.antigravity-exo

Done. Open C:\Users\you\IDEProfiles and launch each shortcut.
```

### Step 4 — Open them

Open `%USERPROFILE%\IDEProfiles\` in File Explorer. You'll see 4 shortcuts. Double-click each one and sign in with a different Antigravity account. That's it.

### Power-user one-liner

If you'd rather paste everything in one go:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force; .\scripts\setup.ps1
```

---

## 🎨 Your 4 profiles

Each profile gets a unique title-bar color so the right window is obvious from the taskbar:

| Profile  | Color              | Suggested use      |
|----------|--------------------|--------------------|
| Tropo    | 🔵 Deep Ocean Blue | Work account       |
| Strato   | 🟤 Dark Amber      | Personal           |
| Meso     | 🟣 Deep Purple     | Client A           |
| Exo      | 🟢 Matrix Green    | Client B / sandbox |

**Why those names?** Tropo / Strato / Meso / Exo are the layers of Earth's atmosphere — fitting for an editor called *Antigravity*. The names are pure convention; pass `-Names Work,Personal,...` if you'd rather use your own. See [Customizing](#-customizing).

---

## 🛠 Customizing

```powershell
# Custom profile names (any number, any labels):
.\scripts\setup.ps1 -Names Work,Personal,Client

# Explicit Antigravity path (if auto-detect missed it):
.\scripts\setup.ps1 -ExePath "D:\Tools\Antigravity\Antigravity.exe"

# Skip auto-applied themes (set colors yourself):
.\scripts\setup.ps1 -SkipThemes

# Put shortcuts on the Desktop instead:
.\scripts\setup.ps1 -ShortcutsDir "$env:USERPROFILE\Desktop"
```

Re-running `setup.ps1` is safe: existing `settings.json` files are not overwritten.

---

## 🎯 Common scenarios

| You want… | Command |
|---|---|
| Only **2** profiles, not 4 | `.\scripts\setup.ps1 -Names Work,Personal` |
| Your own profile names | `.\scripts\setup.ps1 -Names Acme,Globex,Initech` |
| Add a 5th profile later | `.\scripts\setup.ps1 -Names Sandbox` *(adds Sandbox; existing profiles untouched)* |
| Pick your own colors | `.\scripts\setup.ps1 -SkipThemes`, then in each window `Ctrl+,` → `colorCustomizations` |
| Two installs (Antigravity + Insiders) | Run twice, once per `-ExePath`, with different `-Names` |

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

# Back up only Antigravity (if you've also tinkered with -Ide for another fork):
.\scripts\backup.ps1 -Ide Antigravity

# Keep every backup forever:
.\scripts\backup.ps1 -KeepLast 0
```

Backups land in `%USERPROFILE%\IDEProfiles\Backups\`. To move profiles to a new machine, zip them here, copy the zip across, and run `backup.ps1 -Action Restore -From "<path-to-zip>"` on the new box.

---

## 🧹 Uninstall

```powershell
# Remove shortcuts only (profile data kept):
.\scripts\uninstall.ps1

# Remove shortcuts AND profile data (asks to confirm):
.\scripts\uninstall.ps1 -RemoveProfiles
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
In that profile, hit `Ctrl+Shift+P` → **Developer: Reload Window**. If still nothing, verify `%USERPROFILE%\.antigravity-<name>\User\settings.json` exists.

**Windows SmartScreen warns about the .ps1**
Right-click the file → Properties → **Unblock**. Or just paste the script body into a PowerShell window — same effect.

**RAM usage**
Each Electron instance uses ~300MB–1GB. Four instances ≈ 2–4GB. Keep an eye on memory.

---

## ❓ FAQ

**Is this safe? Will running 4 instances flag my Antigravity account?**
You're not bypassing anything. Each instance signs into a separate account, just like opening 4 browsers and logging into 4 accounts. The technique (`--user-data-dir`) is a documented VS Code flag — Antigravity inherits it from its VS Code base.

**Does this modify Antigravity itself?**
No. Multigrav never touches the Antigravity install. It just creates extra data directories and shortcuts that point at the unmodified `Antigravity.exe`.

**What happens when Antigravity updates?**
Your profiles persist. Antigravity updates the executable in place; the profile folders (which contain only your data) keep working exactly as before.

**Do extensions sync between profiles?**
No — that's the whole point. Each profile has its own `extensions` folder. Install Copilot / your formatter / etc. once per profile.

**Can I share profiles across machines?**
Yes — `backup.ps1` zips them up, and `backup.ps1 -Action Restore -From "<zip>"` un-zips them on the new machine. You'll still need to sign in once on each.

**What if I already have an Antigravity install I've been using?**
Untouched. Your default install keeps using its existing data directory. Multigrav profiles live in `%USERPROFILE%\.antigravity-<name>\`, completely separate.

---

## 📁 Repo Structure

```
.
├── scripts/
│   ├── setup.ps1        # Create profiles + themed shortcuts
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

## 🧩 About other IDEs

Multigrav was originally a generic VS Code-fork multi-profile launcher — Cursor was a common use case in the early days. We've since narrowed focus to Antigravity. The `-Ide Cursor` / `-Ide VSCode` flags are still in the scripts as a legacy capability, but aren't tested or supported.

If you're a Cursor / VS Code / Windsurf user and Multigrav happens to work for you — great, but please file issues only for *Antigravity* breakage.

---

## 🤝 Contributing

PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Please test on fresh profile names (`-Names TestA,TestB`) so you don't clobber your own profiles while iterating.

---

## 📄 License

[MIT](LICENSE)

---

⭐ **If Multigrav saved you the pain of signing in and out** — drop a star. It's the single biggest thing that helps other Antigravity users find it. Thanks!
