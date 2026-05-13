# System Tuning — Ubuntu 25.04, 16 GB RAM, NVMe

Goal: free RAM, free disk, reduce background noise, prevent OOM freezes.

Snapshot at start of work (2026-05-07):
- 16 GB RAM, 8.6 GB used, **0 swap configured**
- `~/.cache` was 32 GB
- 4.5 GB Docker images + 2.4 GB build cache, 0 running containers
- 19 active node/claude/tsserver processes, including a stray tsserver indexing `$HOME`
- Heavy enabled services: mysql, postgresql, ollama, docker, smbd, nmbd, openvpn, bluetooth, ModemManager
- Tracker (localsearch-3) and 4 Evolution services running in user session
- 3.9 GB of journald logs

---

## 1. Already applied (this session)

| Action | Result |
| --- | --- |
| `yarn cache clean` | yarn cache emptied |
| `pip cache purge` | 2478 files removed |
| `pnpm store prune` | 48 files / 2 packages removed |
| `go clean -cache` | go-build cache emptied |
| `rm -rf ~/.cache/vscode-cpptools/*` | 5.1 GB freed |
| `npm cache clean --force` | npm cache emptied |
| `rm -rf ~/.ollama` | 1.5 GB of local models removed |
| `systemctl --user mask --now localsearch-3.service` | Tracker indexer disabled |
| `systemctl --user mask --now evolution-{addressbook,calendar,source-registry,alarm-notify}-factory.service` | Evolution background services disabled |
| `gsettings set org.gnome.desktop.interface enable-animations false` | GNOME animations off |

Total reclaimed so far: **~19 GB** in `~/.cache` (32 G → 13 G).

---

## 2. Still to do — copy-paste manually

### 2a. Browser caches (~5–6 GB) — sandbox blocked, run yourself

```bash
find ~/.cache/google-chrome -type d \( -name "Cache" -o -name "Code Cache" -o -name "GPUCache" \) -exec rm -rf {} +
find ~/.cache/mozilla -type d -name "cache2" -exec rm -rf {} +
```

### 2b. Kill the stray `$HOME` tsserver (~1 GB)

```bash
ps -ef | grep "tsserver.js" | grep -v grep            # find PIDs
# Kill any tsserver whose --useInferredProjectPerProjectRoot path is $HOME, NOT a project dir
kill <PID>
```
And avoid running editors directly in `~`. Check for stray triggers:
```bash
ls -la ~/tsconfig.json ~/package.json 2>/dev/null
```

### 2c. Docker prune (~7 GB) — destructive

```bash
docker system prune -a --volumes
```

### 2d. One sudo block — everything else

```bash
# ── Remove Ollama (system side) ────────────────────────────
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm -f /etc/systemd/system/ollama.service
sudo systemctl daemon-reload
sudo rm -f /usr/local/bin/ollama
sudo rm -rf /usr/local/lib/ollama
sudo userdel ollama
sudo groupdel ollama

# ── ZRAM (compressed in-RAM swap, no disk swapfile) ────────
sudo apt install -y systemd-zram-generator
# Then create /etc/systemd/zram-generator.conf with vim — content below.
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

# ── Sysctl tuning ──────────────────────────────────────────
# Create /etc/sysctl.d/99-perf.conf with vim — content below.
sudo sysctl --system

# ── Proactive OOM prevention ───────────────────────────────
sudo systemctl enable --now systemd-oomd

# ── Vacuum journald (3.9 GB → 500 MB) ──────────────────────
sudo journalctl --vacuum-size=500M
# Then edit /etc/systemd/journald.conf with vim — see edit instructions below.
sudo systemctl restart systemd-journald

# ── Disable Ubuntu telemetry / crash reporting ─────────────
sudo systemctl disable --now apport.service whoopsie.service kerneloops.service

# ── Disable heavy services on boot ─────────────────────────
sudo systemctl disable --now mysql postgresql smbd nmbd
sudo systemctl disable docker.service docker.socket
sudo systemctl disable NetworkManager-wait-online.service

# ── noatime mount for / (SSD wear + small IO win) ──────────
# Edit /etc/fstab with vim — see edit instructions below.
grep ' / ' /etc/fstab     # verify before reboot

# ── Clean stale APT sources (.list.save leftovers) ─────────
sudo rm -f /etc/apt/sources.list.d/*.list.save
sudo apt update           # review 404s; remove dead PPAs by hand
```

---

## 2e. File contents for vim

### `/etc/systemd/zram-generator.conf` — create new

```ini
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
```

Open with: `sudo vim /etc/systemd/zram-generator.conf`

### `/etc/sysctl.d/99-perf.conf` — create new

```conf
vm.swappiness=10
vm.vfs_cache_pressure=50
fs.inotify.max_user_watches=524288
```

Open with: `sudo vim /etc/sysctl.d/99-perf.conf`

### `/etc/systemd/journald.conf` — edit existing

Open with: `sudo vim /etc/systemd/journald.conf`

Find the line (commented by default):

```
#SystemMaxUse=
```

Change to:

```
SystemMaxUse=500M
```

### `/etc/fstab` — edit existing

Open with: `sudo vim /etc/fstab`

Find the line for `/` (the root mount). It currently looks something like:

```
UUID=xxxx-xxxx-xxxx  /  ext4  errors=remount-ro  0  1
```

Change the options field (`errors=remount-ro`) to:

```
noatime,errors=remount-ro
```

So the full line becomes:

```
UUID=xxxx-xxxx-xxxx  /  ext4  noatime,errors=remount-ro  0  1
```

Verify with `grep ' / ' /etc/fstab` before rebooting.

---

## 3. Reboot, then verify

```bash
swapon --show                            # should show /dev/zram0
free -h                                  # swap line populated
systemctl is-active systemd-oomd         # active
sysctl vm.swappiness vm.vfs_cache_pressure fs.inotify.max_user_watches
mount | grep ' / '                       # noatime present
journalctl --disk-usage                  # under 500 MB
ls /usr/local/bin/ollama 2>&1            # No such file
```

---

## 4. Ongoing hygiene

- **Don't open editors in `~`.** A `tsconfig.json`/`package.json` at `$HOME` will spawn a TS server that indexes everything. Always work inside a project folder.
- **Close stale Claude CLI sessions.** Each is ~300–400 MB. Same for stale Codex sessions.
- **TypeScript memory cap** in your editor:
  - `"typescript.tsserver.maxTsServerMemory": 3072`
  - Restrict `include`/`exclude` in `tsconfig.json` (drop `node_modules`, `.next`, `dist`, `build`).
- **Start services on demand** instead of on boot:
  ```bash
  sudo systemctl start mysql       # work, then:
  sudo systemctl stop mysql
  ```
- **GNOME extensions audit.** You have 12 enabled. Heaviest: `pano` (clipboard history), `rounded-window-corners`, `tiling-assistant`, `system-monitor`, `space-bar`. Open Extensions Manager and disable anything you don't actively use.

---

## 5. Reversal cheatsheet

| Change | Reverse |
| --- | --- |
| Tracker masked | `systemctl --user unmask localsearch-3.service && systemctl --user start localsearch-3.service` |
| Evolution masked | `systemctl --user unmask evolution-*.service` |
| GNOME animations off | `gsettings reset org.gnome.desktop.interface enable-animations` |
| ZRAM | `sudo rm /etc/systemd/zram-generator.conf && sudo apt remove systemd-zram-generator` |
| sysctl tuning | `sudo rm /etc/sysctl.d/99-perf.conf && sudo sysctl --system` |
| journald cap | edit `/etc/systemd/journald.conf`, comment out `SystemMaxUse` |
| services disabled | `sudo systemctl enable --now <name>` |
| noatime | edit `/etc/fstab` back to `relatime` |

---

## 6. What I deliberately skipped

- **Disk swapfile** — ZRAM is better on SSD. Don't add both; they conflict in priority.
- **`preload`** — abandoned, no benefit on modern kernels.
- **Replacing GNOME with a lighter DE** — big behavior change for modest gain. Trim extensions instead.
- **Snap → deb migration for Firefox** — optional; only worth it if you find Firefox cold-start sluggish.
- **`earlyoom`** — `systemd-oomd` covers the same role and is already shipped.

---

## Expected outcome

- ~30 GB disk reclaimed
- 2–3 GB more usable RAM at idle
- Effective working memory ~24–32 GB (with ZRAM + zstd)
- No more total-freeze OOMs (oomd kills the worst offender)
- Faster boot (NetworkManager-wait-online + heavy services off)
