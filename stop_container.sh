#!/bin/bash
# ========================================================
# Script d'aturada del contenidor Docker GUI
# Versió final - ASIXcC ITB
# ========================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Capçalera
clear
echo -e "\e[1;36m"
echo "#######################################################"
echo "#       A1 - ATURADA DEL CONTENIDOR - M09 UF2         #"
echo "#                                                     #"
echo "#           Roger Domingo & Iker Blazquez             #"
echo "#                   ASIXcC - ITB                      #"
echo "#######################################################"
echo -e "\e[0m"

# Verificació de permisos
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR] Aquest script s'ha d'executar amb sudo${NC}" >&2
    exit 1
fi

# Configuració
CONTAINER_NAME="asix-gui-rdib-container"
IMAGE_NAME="asix-gui-rdib"

# 1. Aturar el contenidor
echo -e "${YELLOW}[INFO] Aturant el contenidor...${NC}"
if docker stop $CONTAINER_NAME 2>/dev/null; then
    echo -e "${GREEN}[ÈXIT] Contenidor aturat correctament${NC}"
else
    echo -e "${RED}[AVÍS] No s'ha pogut aturar el contenidor (potser no estava en execució?)${NC}"
fi

# 2. Eliminar el contenidor
echo -e "\n${YELLOW}[INFO] Eliminant el contenidor...${NC}"
if docker rm $CONTAINER_NAME 2>/dev/null; then
    echo -e "${GREEN}[ÈXIT] Contenidor eliminat correctament${NC}"
else
    echo -e "${RED}[AVÍS] No s'ha pogut eliminar el contenidor${NC}"
fi

# 3. Opció per eliminar la imatge
echo -e "\n${BLUE}Opció addicional:${NC}"
read -p "Vols eliminar també la imatge Docker? (s/n): " choice
if [ "$choice" = "s" ] || [ "$choice" = "S" ]; then
    echo -e "${YELLOW}[INFO] Eliminant la imatge...${NC}"
    if docker rmi $IMAGE_NAME 2>/dev/null; then
        echo -e "${GREEN}[ÈXIT] Imatge eliminada correctament${NC}"
    else
        echo -e "${RED}[AVÍS] No s'ha pogut eliminar la imatge${NC}"
    fi
fi

# 4. Neteja addicional (opcional)
echo -e "\n${YELLOW}[INFO] Netejant recursos no utilitzats...${NC}"
docker system prune -f

# Missatge final
echo -e "\n${BLUE}======================================================="
echo -e "  PROCÉS D'ATURADA COMPLETAT"
echo -e "=======================================================${NC}"
echo -e "${GREEN}Estat final:${NC}"
docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
echo -e "\n${BLUE}=======================================================${NC}"