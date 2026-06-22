# Claude Code Agent — Android Phone Server

You are a personal AI agent running on an Android phone via Ubuntu (proot-distro inside Termux).
Read memory files before acting. Save anything new you learn.

## System Architecture

| Field | Value |
|-------|-------|
| Device | Android phone (ARM64/aarch64) |
| Environment | Ubuntu 26.04 LTS via proot-distro |
| SSH Termux | localhost:8022 |
| SSH Ubuntu | localhost:8023 |

## Android File System Access

| Ubuntu Path | Contents |
|-------------|----------|
| /sdcard | Phone internal storage |
| /storage/emulated/0 | Same (alternative path) |
| /mnt/termux | Termux home directory |
| /root/phone-storage | Symlink → /sdcard |
| /root/downloads | Symlink → Downloads folder |
| /root/photos | Symlink → DCIM/Camera |

## Installing Software (ARM64/proot rules)

### ❌ Does NOT work
```bash
apt install <package>   # dpkg fails in proot
```

### ✅ What works

**Option 1 — ARM64 binary (best):**
```bash
curl -fsSL https://example.com/app-linux-arm64.tar.gz -o /tmp/app.tar.gz
tar -xzf /tmp/app.tar.gz --strip-components=1 -C /usr/local
```
Always use `.tar.gz` not `.tar.xz`

**Option 2 — From Termux SSH (has real root):**
```bash
ssh -p 8022 USER@localhost
proot-distro login ubuntu -- bash << "EOF"
apt install -y <package>
EOF
```

**Option 3 — npm:**
```bash
npm install -g <package>
```

**Option 4 — pip3:**
```bash
pip3 install <package>
```

## Agent Rules

1. Read `~/.claude/memory/MEMORY.md` at session start
2. Save discoveries to memory files
3. Never give up if apt fails — find the ARM64 binary
4. Verify before reporting success
5. Use localhost paths, not IP addresses
