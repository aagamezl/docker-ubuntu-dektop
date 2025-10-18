# Docker Ubuntu Desktop with XRDP

A Docker container that provides a full Ubuntu Desktop environment accessible via RDP (Remote Desktop Protocol). This setup is ideal for development, testing, or running GUI applications in a containerized environment.

## Features

- Ubuntu 24.04 LTS base with GNOME desktop environment
- XRDP server for remote desktop access (port 3389)
- Google Chrome pre-installed
- Optional X11 forwarding support
- User management with sudo privileges
- Optimized XRDP performance settings
- Persistent storage via Docker volumes

## Prerequisites

- Docker Engine
- Docker Compose
- RDP client (Windows Remote Desktop, Remmina, etc.)

## Quick Start

### 1. Clone the repository:

```bash
   git clone https://github.com/yourusername/docker-ubuntu-desktop.git
   cd docker-ubuntu-desktop
   ```

### 2. Start the container

```bash
./restart.sh

# or

docker-compose up -d
```

### 3. Connect to the desktop using an RDP client

- Address: `localhost:3389`
- Username: `test`
- Password: `1234`

## Customization

### Environment Variables

You can customize the container by modifying the following build arguments in the `Dockerfile`:

- `USER`: Username for the default user (default: `test`)
- `PASS`: Password for the default user (default: `1234`)
- `X11Forwarding`: Set to `true` to enable SSH X11 forwarding (default: `false`)

### Persistent Storage

The Docker Compose configuration includes a volume mount at `/home/dockeruser/data` which is mapped to `./data` on your host machine.

## File Structure

- `Dockerfile`: Defines the container image with Ubuntu, GNOME, XRDP, and other dependencies
- `docker-compose.yml`: Docker Compose configuration for easy container management
- `restart.sh`: Helper script to rebuild and restart the container
- `data/`: Directory for persistent storage (mapped to `/home/dockeruser/data` in the container)
- `documentation.md`: Additional documentation and usage notes

## Security Notes

- The default credentials (test/1234) should be changed for production use
- XRDP is configured with performance optimizations that may reduce security
- Consider using SSH tunneling for secure remote access in production environments

## Troubleshooting

- If you encounter connection issues, ensure port 3389 is not in use by another service
- Check container logs with `docker logs ubuntu-gnome-rdp`
- For X11 forwarding issues, verify the X11 server is running on your host

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
