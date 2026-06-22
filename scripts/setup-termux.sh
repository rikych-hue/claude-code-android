#!/data/data/com.termux/files/usr/bin/bash
# setup-termux.sh — Run this in Termux to set up SSH and install proot-distro
# Download Termux from F-Droid ONLY: https://f-droid.org/en/packages/com.termux/

set -e

echo "=== Claude Code Android Setup — Step 1: Termux ==="
echo ""

# Update packages
echo "[1/4] Updating packages..."
pkg update -y

# Install required packages
echo "[2/4] Installing SSH and proot-distro..."
pkg install -y openssh proot-distro

# Set password for SSH
echo "[3/4] Setting SSH password..."
echo ""
echo "Choose a password for SSH access to Termux:"
passwd

# Configure auto-start
echo "[4/4] Configuring auto-start..."
cat > ~/.bashrc << 'EOF'
# Keep Termux alive (prevents Android from killing it)
termux-wake-lock 2>/dev/null &

# SSH server on port 8022
sshd 2>/dev/null

# Ubuntu SSH on port 8023 (run after setup-ubuntu.sh)
if proot-distro list | grep -q "ubuntu.*installed"; then
  proot-distro login ubuntu \
    --bind /data/data/com.termux/files/home:/mnt/termux \
    -- bash -c "mkdir -p /run/sshd && /usr/sbin/sshd" 2>/dev/null &
fi

echo "Termux SSH  :8022 ready"
echo "Ubuntu SSH  :8023 ready (if installed)"
EOF

# Start SSH now
sshd

echo ""
echo "=== Done! ==="
echo ""
echo "Your phone's IP:"
ifconfig 2>/dev/null | grep 'inet ' | grep -v '127' | awk '{print $2}' | head -1
echo ""
echo "SSH command from your PC:"
echo "  ssh -p 8022 $(whoami)@YOUR_PHONE_IP"
echo ""
echo "NEXT STEP: Run ADB commands from your PC (see README.md)"
echo "THEN: Run setup-ubuntu.sh inside Termux"
