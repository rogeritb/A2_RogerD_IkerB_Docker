# ========================================================
# Dockerfile per a Entorn GUI amb XFCE, VNC i SSH
# Versió 100% funcional - ASIXcC ITB
# ========================================================

FROM ubuntu:24.04

# Variables d'entorn
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Madrid \
    USER=developer \
    VNC_PASSWD=developer \
    VNC_DISPLAY=:1 \
    VNC_RESOLUTION=1280x800 \
    DISPLAY=:1

# 1. Actualització i paquets bàsics
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        ca-certificates \
        locales \
        tzdata \
    && rm -rf /var/lib/apt/lists/* && \
    localedef -i ca_ES -c -f UTF-8 -A /usr/share/locale/locale.alias ca_ES.UTF-8

# 2. Instal·lació de l'entorn complet (amb TigerVNC)
RUN apt-get update && \
    apt-get install -y \
        xfce4 \
        xfce4-goodies \
        tigervnc-standalone-server \
        tigervnc-common \
        openssh-server \
        sudo \
        wget \
        curl \
        git \
        nano \
        net-tools \
        iputils-ping \
        python3 \
        python3-pip \
        expect \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Instal·lació de Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && \
    apt-get install -y code && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. Configuració de l'usuari
RUN useradd -m -s /bin/bash ${USER} && \
    echo "${USER}:${VNC_PASSWD}" | chpasswd && \
    usermod -aG sudo ${USER} && \
    mkdir -p /home/${USER}/.vnc && \
    chown -R ${USER}:${USER} /home/${USER}

# 5. Configuració de VNC
COPY set_vnc_password.exp /tmp/
RUN chmod +x /tmp/set_vnc_password.exp && \
    /tmp/set_vnc_password.exp ${USER} ${VNC_PASSWD} && \
    echo -e "#!/bin/sh\nunset SESSION_MANAGER\nexec /usr/bin/xfce4-session" > /home/${USER}/.vnc/xstartup && \
    chmod +x /home/${USER}/.vnc/xstartup && \
    rm /tmp/set_vnc_password.exp

# 6. Configuració de SSH (corregida)
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config && \
    echo "AllowUsers ${USER}" >> /etc/ssh/sshd_config && \
    ssh-keygen -A

# 7. Comanda d'inici (corregida)
CMD bash -c "sudo -u ${USER} vncserver ${VNC_DISPLAY} -geometry ${VNC_RESOLUTION} -depth 24 -localhost no -SecurityTypes=VncAuth -PasswordFile=/home/${USER}/.vnc/passwd && \
    /usr/sbin/sshd -D"

# Exposició de ports
EXPOSE 22 5901

# Metadades
LABEL maintainer="Roger Domingo & Iker Blazquez"
LABEL version="5.0"
LABEL description="Entorn GUI amb XFCE, VNC i SSH - Versió definitiva"