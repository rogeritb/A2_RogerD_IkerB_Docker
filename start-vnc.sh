#!/bin/bash

# Configuració bàsica del sistema
echo "Configurant l'entorn..."
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# Inici del servidor SSH
echo "Iniciant el servidor SSH..."
service ssh start

# Inici del servidor VNC
echo "Iniciant el servidor VNC amb resolució $RESOLUTION..."
vncserver -kill :1 >/dev/null 2>&1 || true
vncserver -geometry $RESOLUTION :1

# Inici de l'entorn gràfic XFCE
echo "Iniciant l'entorn gràfic XFCE..."
startxfce4 >/dev/null 2>&1 &

# Configuració de Visual Studio Code
mkdir -p /root/.vscode-server /root/.vscode-server-insiders
chmod 700 /root/.vscode-server*

# Informació de connexió
echo "============================================"
echo "Entorn GUI configurat correctament"
echo "--------------------------------------------"
echo "VNC Server:"
echo "  Port: 5901"
echo "  Password: $VNC_PASSWORD"
echo "SSH Server:"
echo "  Port: 22"
echo "  Usuari: root"
echo "  Password: $SSH_PASSWORD"
echo "--------------------------------------------"
echo "Visual Studio Code i Python estan instal·lats"
echo "============================================"

# Mantenir el contenidor actiu
tail -f /dev/null