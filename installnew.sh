#!/bin/bash

# ============================================================
#  Shortie - Auto Install Script for Ubuntu VPS / Droplet
#  Run as root: bash installnew.sh
# ============================================================

set -e

# ─── CONFIG ────────────────────────────────────────────────
MONGO_URI="mongodb+srv://snaplivepk:Amir.Aa.786@cluster0.z6svduu.mongodb.net/shortie?appName=Cluster0"
BACKEND_PORT=5000
FRONTEND_PORT=5001
INSTALL_DIR="/var/www/shortie"
# ───────────────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✔] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }

echo ""
echo "======================================================"
echo "        Shortie VPS Auto-Installer"
echo "======================================================"
echo ""

# ── 1. System Update ─────────────────────────────────────
log "Updating system packages..."
apt-get update -qq && apt-get upgrade -y -qq

# ── 2. Install Node.js 18 ────────────────────────────────
log "Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash - > /dev/null 2>&1
apt-get install -y nodejs > /dev/null 2>&1
log "Node.js version: $(node -v)"

# ── 3. Install PM2 & Nginx ───────────────────────────────
log "Installing PM2 and Nginx..."
npm install -g pm2 > /dev/null 2>&1
apt-get install -y nginx > /dev/null 2>&1

# ── 4. Copy project files ────────────────────────────────
log "Setting up project directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Copy backend and frontend from current directory (where you ran this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp -r "$SCRIPT_DIR/backend"  "$INSTALL_DIR/"
cp -r "$SCRIPT_DIR/frontend" "$INSTALL_DIR/"

# ── 5. Backend Setup ─────────────────────────────────────
log "Installing backend dependencies..."
cd "$INSTALL_DIR/backend"
npm install --silent

# Apply .env
log "Configuring backend .env..."
cat > .env << EOF
PORT = $BACKEND_PORT
projectName = Shortie
JWT_SECRET = 2FhKmINItB
EMAIL = kodebookapp@gmail.com
APP_PASSWORD = nohwrpybgiuhqjfy
baseURL = http://localhost/
secretKey = 5TIvw5cpc0
MongoDb_Connection_String = $MONGO_URI
EOF

# Apply purchase code bypass
log "Applying purchase code bypass..."
cat > node_modules/jago-maldar/index.js << 'EOF'
// Bypass: always return true
module.exports = async function Auth() { return true; };
EOF

# Start backend with PM2
log "Starting backend with PM2..."
pm2 delete shortie-backend 2>/dev/null || true
pm2 start index.js --name "shortie-backend"

# ── 6. Frontend Setup ────────────────────────────────────
log "Installing frontend dependencies..."
cd "$INSTALL_DIR/frontend"
npm install --silent

# Update API base URL
log "Configuring frontend API URL..."
cat > src/util/config.ts << 'EOF'
export const baseURL: string = "http://localhost/";
export const secretKey: string = "5TIvw5cpc0";
export const projectName: string = "Shortie";
EOF

# Build Next.js
log "Building frontend (this may take a minute)..."
npm run build

# Start frontend with PM2
log "Starting frontend with PM2..."
pm2 delete shortie-frontend 2>/dev/null || true
pm2 start npm --name "shortie-frontend" -- start

# Save PM2 processes
pm2 save
pm2 startup systemd -u root --hp /root | tail -1 | bash

# ── 7. Nginx Config ──────────────────────────────────────
log "Configuring Nginx..."
cat > /etc/nginx/sites-available/shortie << EOF
server {
    listen 80;
    server_name _;

    client_max_body_size 100M;

    # Frontend
    location / {
        proxy_pass http://localhost:$FRONTEND_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    # Backend API
    location /admin/ {
        proxy_pass http://localhost:$BACKEND_PORT/admin/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /client/ {
        proxy_pass http://localhost:$BACKEND_PORT/client/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /storage/ {
        proxy_pass http://localhost:$BACKEND_PORT/storage/;
    }
}
EOF

# Enable site
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/shortie /etc/nginx/sites-enabled/shortie
nginx -t && systemctl restart nginx

# ── 8. Done ──────────────────────────────────────────────
echo ""
echo "======================================================"
log "Installation Complete!"
echo ""
echo "  Admin Panel  →  http://$(curl -s ifconfig.me 2>/dev/null || echo YOUR_SERVER_IP)"
echo "  Backend API  →  http://$(curl -s ifconfig.me 2>/dev/null || echo YOUR_SERVER_IP)/admin/"
echo ""
echo "  Default Login:"
echo "    Email:    admin@shortie.com"
echo "    Password: Admin@123"
echo ""
echo "  PM2 Status:"
pm2 list
echo "======================================================"
