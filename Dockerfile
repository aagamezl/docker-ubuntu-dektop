FROM ubuntu:24.04
EXPOSE 3389/tcp
ARG USER=test
ARG PASS=1234
ARG X11Forwarding=false

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install tzdata and set the timezone to UTC
RUN apt-get update && \
    apt-get install -y tzdata && \
    echo "Etc/UTC" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install GNOME, XRDP, and optional SSH for X11 forwarding
RUN apt-get update && \
    apt-get install -y dbus-x11 xrdp sudo openssl gnome-shell ubuntu-desktop-minimal gnome-console && \
    if [ "$X11Forwarding" = "true" ]; then apt-get install -y openssh-server; fi && \
    apt-get autoremove -y --purge && \
    apt-get clean

# Install Chrome, curl, git
RUN apt-get update && \
    apt-get install -y wget curl git gnupg && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Remove the reboot required file
RUN rm -f /run/reboot-required* || true

# Create a user and add it to the sudo group
RUN useradd -s /bin/bash -m $USER -p "$(openssl passwd "$PASS")" && \
    usermod -aG sudo $USER && \
    adduser xrdp ssl-cert

# Set GNOME environment variables for XRDP
RUN echo 'LANG=en_US.UTF-8' >> /etc/default/locale && \
    echo 'export GNOME_SHELL_SESSION_MODE=ubuntu' > /home/$USER/.xsessionrc && \
    echo 'export XDG_CURRENT_DESKTOP=ubuntu:GNOME' >> /home/$USER/.xsessionrc && \
    echo 'export XDG_SESSION_TYPE=x11' >> /home/$USER/.xsessionrc

# Enable console logs and optimize XRDP performance
RUN sed -i "s/#EnableConsole=false/EnableConsole=true/g" /etc/xrdp/xrdp.ini && \
    sed -i 's/max_bpp=32/max_bpp=16/g' /etc/xrdp/xrdp.ini && \
    gsettings set org.gnome.desktop.interface enable-animations true

# Configure SSH for X11 forwarding
RUN if [ "$X11Forwarding" = "true" ]; then \
        sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config; \
    fi

# Allow passwordless sudo for the user
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$USER

CMD rm -f /var/run/xrdp/xrdp*.pid >/dev/null 2>&1; \
    service dbus restart >/dev/null 2>&1; \
    /usr/lib/systemd/systemd-logind >/dev/null 2>&1 & \
    [ -f /usr/sbin/sshd ] && /usr/sbin/sshd; \
    xrdp-sesman --config /etc/xrdp/sesman.ini; \
    xrdp --nodaemon --config /etc/xrdp/xrdp.ini
