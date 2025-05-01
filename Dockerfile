# Dockerfile - Entorn GUI amb Ubuntu 24.04
FROM ubuntu:24.04

# Configuració bàsica
ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PASSWORD=password \
    VNC_RESOLUTION=1280x720 \
    DISPLAY=:1

# Instal·lar dependències principals
RUN apt-get update && apt-get install -y \
    xfce4 \
    tightvncserver \
    xfce4-terminal \
    wget \
    git \
    openssh-server \
    python3 \
    python3-pip \
    firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instal·lar Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update \
    && apt-get install -y code \
    && apt-get clean

# Configurar VNC
RUN mkdir /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Copiar configuració VNC
COPY vnc-config/xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# Ports exposats
EXPOSE 5901 22 8080

# Script d'inici
COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]