DOCKER GUI - ENTORN DE DESENVOLUPAMENT AMB XFCE

Aquest projecte crea un contenidor Docker amb Ubuntu 24.04 que inclou:
- Entorn gràfic XFCE
- Servidor VNC per accés remot
- Visual Studio Code
- Python 3
- Servidor SSH

REQUERIMENTS PREVIS:
- Docker instal·lat
- Client VNC (Recomanat Remmina)
- Mínim 4GB de RAM
- 10GB d'espai lliure

INSTRUCCIONS D'INSTAL·LACIÓ:

1. Descarregar el projecte:
git clone https://github.com/el-teu-repo/docker-gui-project.git
cd docker-gui-project

2. Construir la imatge Docker:
docker build -t ubuntu-xfce-vnc .

3. Executar el contenidor:
docker run -d \
  -p 5901:5901 \
  -p 2222:22 \
  --name gui-container \
  --security-opt seccomp=unconfined \
  ubuntu-xfce-vnc

CONFIGURACIÓ DELS PORTS:
- 5901: Port per a VNC
- 2222: Port per a SSH (redireccionat al port 22 del contenidor)

CONNEXIÓ AMB VNC:
1. Obrir el client Remmina
2. Seleccionar protocol VNC
3. Introduir adreça: localhost:5901
4. Contrasenya: password (per defecte)

ACCÉS PER SSH:
ssh -p 2222 developer@localhost
Contrasenya: developer

CONFIGURACIÓ ADDICIONAL:

Per canviar la contrasenya de VNC:
1. Editar el Dockerfile:
   Canviar la línia:
   RUN echo "password" | vncpasswd -f > /root/.vnc/passwd
2. Reconstruir la imatge

Per instal·lar extensions a VSCode:
docker exec -it gui-container code --install-extension EXTENSIO_ID

ESTRUCTURA DEL PROJECTE:
.
├── Dockerfile
├── README.txt
└── start_vnc.sh

SOLUCIÓ DE PROBLEMES:

Si la connexió VNC falla:
1. Verificar que el contenidor està executant-se:
   docker ps -a
2. Comprovar els logs:
   docker logs gui-container

Si es necessari redireccionar ports a VirtualBox:
1. Anar a Configuració > Xarxa
2. Afegir regla de Port Forwarding:
   - Protocol: TCP
   - Port host: 5901
   - Port invitau: 5901

CRÈDITS:
Projecte desenvolupat per [El teu nom]
Curs ASIX 2024
Centre: [Nom del teu centre]