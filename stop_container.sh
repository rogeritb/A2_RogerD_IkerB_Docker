#!/bin/bash
# ========================================================
# Script d'aturada del contenidor Docker GUI
# ASIXcC ITB
# ========================================================

# Configuració
CONTAINER_NAME="my-gui-env"
IMAGE_NAME="ubuntu-xfce-vnc"

# Capçalera
echo "======================================================="
echo "       A1 - ATURADA DEL CONTENIDOR - M09 UF2"
echo ""
echo "           Roger Domingo & Iker Blazquez"
echo "                   ASIXcC - ITB"
echo "======================================================="

# 1. Aturar el contenidor
echo "[INFO] Aturant el contenidor..."
if docker stop $CONTAINER_NAME 2>/dev/null; then
    echo "[OK] Contenidor aturat"
else
    echo "[WARN] No s'ha pogut aturar (potser no estava en execució?)"
fi

# 2. Eliminar el contenidor
echo ""
echo "[INFO] Eliminant el contenidor..."
if docker rm $CONTAINER_NAME 2>/dev/null; then
    echo "[OK] Contenidor eliminat"
else
    echo "[WARN] No s'ha pogut eliminar"
fi

# 3. Opció per eliminar la imatge
echo ""
read -p "Vols eliminar també la imatge Docker? (s/n): " choice
if [ "$choice" = "s" ] || [ "$choice" = "S" ]; then
    echo "[INFO] Eliminant la imatge..."
    if docker rmi $IMAGE_NAME 2>/dev/null; then
        echo "[OK] Imatge eliminada"
    else
        echo "[WARN] No s'ha pogut eliminar la imatge"
    fi
fi

# 4. Neteja addicional
echo ""
echo "[INFO] Netejant recursos no utilitzats..."
docker system prune -f

# Final
echo ""
echo "======================================================="
echo "  PROCÉS D'ATURADA COMPLETAT"
echo "======================================================="
docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
echo "======================================================="