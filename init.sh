# Clean up
docker stop ubuntu-gnome-rdp 2>/dev/null || true
docker rm ubuntu-gnome-rdp 2>/dev/null || true

# Build
# docker build -t ubuntu-gnome-rdp .

# Run
docker-compose up -d