#!/data/data/com.termux/files/usr/bin/bash
# setup-ubuntu.sh — Run in Termux to install Ubuntu + Node.js + Claude Code
# Run AFTER setup-termux.sh and adb-setup.bat

set -e

echo "=== Claude Code Android Setup — Ubuntu + Claude Code ==="
echo ""

# Install Ubuntu
echo "[1/5] Installing Ubuntu via proot-distro..."
proot-distro install ubuntu

# Install Node.js via ARM64 binary (apt/dpkg don't work in proot)
echo "[2/5] Installing Node.js 22 LTS (ARM64 binary method)..."
proot-distro login ubuntu -- bash << 'UBUNTU'
echo "Downloading Node.js 22 LTS for ARM64..."
curl -fsSL https://nodejs.org/dist/v22.16.0/node-v22.16.0-linux-arm64.tar.gz \
  -o /tmp/node.tar.gz

echo "Extracting..."
tar -xzf /tmp/node.tar.gz --strip-components=1 -C /usr/local
rm /tmp/node.tar.gz

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
UBUNTU

# Install Claude Code
echo "[3/5] Installing Claude Code..."
proot-distro login ubuntu -- bash << 'UBUNTU'
npm install -g @anthropic-ai/claude-code
echo "Claude Code version: $(claude --version)"
UBUNTU

# Configure Ubuntu SSH on port 8023
echo "[4/5] Configuring Ubuntu SSH on port 8023..."
proot-distro login ubuntu -- bash << 'UBUNTU'
apt install -y openssh-server curl wget nano 2>/dev/null || true

# SSH config
grep -q "Port 8023" /etc/ssh/sshd_config || echo "Port 8023" >> /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Generate host keys
ssh-keygen -A 2>/dev/null || true

# Start SSH
mkdir -p /run/sshd
/usr/sbin/sshd
echo "Ubuntu SSH started on port 8023"
UBUNTU

# Create symlinks to Android storage
echo "[5/5] Setting up Android storage access..."
proot-distro login ubuntu -- bash << 'UBUNTU'
mkdir -p /mnt/termux
ln -sf /sdcard /root/phone-storage 2>/dev/null || true
ln -sf /sdcard/Download /root/downloads 2>/dev/null || true
ln -sf /sdcard/DCIM /root/photos 2>/dev/null || true
echo "Storage symlinks created"
UBUNTU

echo ""
echo "================================================"
echo "  Installation Complete!"
echo "================================================"
echo ""
echo "Connect to Ubuntu from your PC:"
echo "  ssh -t -p 8023 root@YOUR_PHONE_IP"
echo ""
echo "Run Claude Code:"
echo "  claude"
echo ""
echo "Note: Use 'ssh -t' flag for interactive Claude Code session"
echo ""
echo "IMPORTANT: Authenticate Claude Code on first run"
echo "  Option A: claude /login (browser OAuth)"
echo "  Option B: export ANTHROPIC_API_KEY='sk-ant-...'"
