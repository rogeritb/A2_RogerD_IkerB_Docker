# ========================================================
# Dockerfile per a Entorn GUI amb XFCE, VNC i SSH
# ASIXcC ITB
# ========================================================

# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# ========================================================
# Metadades
# ========================================================
LABEL maintainer="Roger Domingo & Iker Blazquez"
LABEL version="5.0"
LABEL description="Entorn GUI amb XFCE, VNC i SSH"

# Configuració bàsica
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV RESOLUTION=1920x1080
ENV VNC_PASSWORD=password
ENV SSH_PASSWORD=password

# Instal·lació de paquets bàsics
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    gnupg \
    git \
    sudo \
    openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instal·lació de l'entorn gràfic
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    xfonts-base \
    x11-apps \
    xterm \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instal·lació de Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
    && apt-get update \
    && apt-get install -y code \
    && rm -f packages.microsoft.gpg

# Instal·lació de Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configuració del servidor SSH
RUN mkdir /var/run/sshd \
    && echo "root:$SSH_PASSWORD" | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && ssh-keygen -A

# Configuració del servidor VNC
RUN mkdir -p /root/.vnc \
    && echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd \
    && touch /root/.Xauthority

# Creació del script d'inici
COPY start-vnc.sh /app/start-vnc.sh
RUN chmod +x /app/start-vnc.sh

# Configuració dels ports
EXPOSE 5901 22

# Directori de treball
WORKDIR /app

# Entrada
ENTRYPOINT ["/app/start-vnc.sh"]