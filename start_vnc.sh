#!/bin/bash

#############################################################
# CONFIGURADOR DOCKER GUI XFCE/VNC - Roger D & Iker B - ITB
# 
# Aquest script:
# 1. Crea la imatge Docker amb tot l'entorn GUI
# 2. Inicia el contenidor amb els ports correctes
# 3. Proporciona les credencials d'accés
#############################################################

# Funció per mostrar missatges amb colors
function mostrar_missatge {
    case $1 in
        "verd") echo -e "\033[0;32m[+] $2\033[0m" ;;
        "vermell") echo -e "\033[0;31m[!] $2\033[0m" ;;
        "blau") echo -e "\033[0;34m[i] $2\033[0m" ;;
        *) echo "[*] $2" ;;
    esac
}

# Funció per verificar dependències
function verificar_dependencias {
    local dependencias=("docker" "git" "curl")
    for dep in "${dependencias[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            mostrar_missatge "vermell" "ERROR: $dep no està instal·lat"
            exit 1
        fi
    done
}

# Funció per construir la imatge Docker
function construir_imatge {
    mostrar_missatge "blau" "Construint la imatge Docker (pot trigar uns minuts)..."
    docker build -t ubuntu-xfce-vnc . || {
        mostrar_missatge "vermell" "Error en construir la imatge"
        exit 1
    }
}

# Funció per iniciar el contenidor
function iniciar_contenidor {
    mostrar_missatge "blau" "Iniciant el contenidor..."
    docker run -d \
        -p 5901:5901 \
        -p 2222:22 \
        --name gui-container \
        --restart unless-stopped \
        ubuntu-xfce-vnc || {
        mostrar_missatge "vermell" "Error en iniciar el contenidor"
        exit 1
    }
}

# Funció per mostrar informació de connexió
function mostrar_info_connexio {
    echo ""
    mostrar_missatge "verd" "CONFIGURACIÓ COMPLETADA AMB ÈXIT"
    echo "============================================"
    mostrar_missatge "blau" "CREDENCIALS D'ACCÉS:"
    echo ""
    echo -e "\033[0;36m[VNC]\033[0m"
    echo "  Adreça: localhost:5901"
    echo "  Contrasenya: password"
    echo "  Client recomanat: Remmina"
    echo ""
    echo -e "\033[0;36m[SSH]\033[0m"
    echo "  Comanda: ssh developer@localhost -p 2222"
    echo "  Contrasenya: developer"
    echo ""
    echo -e "\033[0;36m[VSCODE]\033[0m"
    echo "  Dins del contenidor, executa:"
    echo "  $ code"
    echo ""
    echo "============================================"
    mostrar_missatge "blau" "Per aturar el contenidor: docker stop gui-container"
}

# Main
clear
echo "#######################################################"
echo "#    CONFIGURADOR DOCKER GUI XFCE/VNC - M09 UF2       #"
echo "#                                                     #"
echo "#           Roger Domingo & Iker Blazquez             #"
echo "#               ITB Barcelona - ASIX                  #"
echo "#######################################################"
echo ""

# Verificar dependències
verificar_dependencias

# Aturar contenidors existents
if docker ps -a | grep -q "gui-container"; then
    mostrar_missatge "taronja" "Aturant contenidor existent..."
    docker stop gui-container >/dev/null 2>&1
    docker rm gui-container >/dev/null 2>&1
fi

# Construir i executar
construir_imatge
iniciar_contenidor

# Comprovar estat
sleep 3
if docker ps | grep -q "gui-container"; then
    mostrar_info_connexio
else
    mostrar_missatge "vermell" "El contenidor no s'ha iniciat correctament"
    docker logs gui-container
    exit 1
fi
