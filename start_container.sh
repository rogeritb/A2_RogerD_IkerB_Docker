#!/bin/bash
# ========================================================
# Script d'inici del contenidor Docker GUI
# Versió definitiva - ASIXcC ITB
# ========================================================

# Verificació de permisos
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\e[31m[ERROR] Aquest script s'ha d'executar amb sudo\e[0m" >&2
    exit 1
fi

# Configuració
IMAGE_NAME="asix-gui-RDIB"
CONTAINER_NAME="asix-gui-RDIB-container"
VNC_PORT=5901
SSH_PORT=2222
VNC_PASSWORD="developer"  # Canviar en entorns reals

# Funció per mostrar missatges d'estat
show_message() {
    echo -e "\e[1;34m[INFO] $1\e[0m"
}

# Funció per mostrar errors
show_error() {
    echo -e "\e[1;31m[ERROR] $1\e[0m" >&2
    exit 1
}

# Capçalera
clear
echo -e "\e[1;36m"
echo "#######################################################"
echo "#    A1 - DESPLEGAMENT DOCKER DEFINITIU - M09 UF2     #"
echo "#                                                     #"
echo "#           Roger Domingo & Iker Blazquez             #"
echo "#                   ASIXcC - ITB                      #"
echo "#######################################################"
echo -e "\e[0m"

# 1. Aturar i eliminar contenidors existents
show_message "Netejant contenidors anteriors..."
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

# 2. Construcció de la imatge
show_message "Construint la imatge Docker..."
docker build --no-cache -t $IMAGE_NAME . || show_error "Error en construir la imatge"

# 3. Execució del contenidor
show_message "Iniciant el contenidor..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $VNC_PORT:5901 \
    -p $SSH_PORT:22 \
    -e VNC_PASSWD=$VNC_PASSWORD \
    -e VNC_RESOLUTION=1280x800 \
    --restart unless-stopped \
    $IMAGE_NAME || show_error "Error en iniciar el contenidor"

# 4. Verificació
sleep 5  # Espera per assegurar l'arrencada
show_message "Verificant l'estat del contenidor..."
docker ps -f "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"

# 5. Informació de connexió
echo -e "\n\e[1;35m======================================================="
echo "           CREDENCIALS D'ACCÉS"
echo -e "\e[1;35m=======================================================\e[0m"
echo -e "\e[1;33mVNC (Remmina):\e[0m"
echo "  Adreça: localhost:$VNC_PORT"
echo "  Usuari: developer"
echo "  Contrasenya: $VNC_PASSWORD"
echo ""
echo -e "\e[1;33mSSH:\e[0m"
echo "  Comanda: ssh -p $SSH_PORT developer@localhost\e[0m"
echo "  Contrasenya: developer"
echo ""
echo -e "\e[1;35m=======================================================\e[0m"
echo -e "\e[1;32m[INFO] Per aturar el contenidor, executeu:"
echo -e "  sudo ./stop_container.sh"
echo -e "\e[1;35m=======================================================\e[0m"