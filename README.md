# README - Entorn GUI Docker amb XFCE, VNC i SSH
=============================================

ASIXcC ITB - M09 UF2

Autors: Roger Domingo & Iker Blazquez

## ESTRUCTURA DEL PROJECTE
-----------------------
.
 Dockerfile                  # Configuració principal del contenidor
 start-vnc.sh                # Script d'inici del contenidor
 stop_container.sh           # Script per aturar i netejar el contenidor
 README.md                   # Aquest document d'instruccions

## DESCRIPCIÓ DELS FITXERS
-----------------------
1. Dockerfile:
   - Configura la imatge base Ubuntu 24.04
   - Instal·la XFCE, VNC, SSH, VSCode i Python
   - Defineix ports i variables d'entorn
   - Copia els scripts necessaris

2. start-vnc.sh:
   - Inicia els serveis SSH i VNC
   - Configura l'entorn gràfic XFCE
   - Mostra informació de connexió

3. stop_container.sh:
   - Atura i elimina el contenidor
   - Opció per eliminar la imatge
   - Neteja recursos no utilitzats

## REQUISITS PREVIS
----------------
- Docker instal·lat
- Client VNC (Recomanat: Remmina)
- Client SSH

## INSTRUCCIONS D'INSTAL·LACIÓ I EXECUCIÓ
--------------------------------------

0. Recorda en donar permisos d'execució als fitxers .sh
   chmod +x *.sh

1. CONSTRUIR LA IMATGE DOCKER:
   Executeu des del directori que conté el Dockerfile:
   
   docker build -t ubuntu-xfce-vnc .

2. INICIAR EL CONTENIDOR:
   docker run -d \
  -p 5901:5901 \
  -p 2222:22 \
  --name my-gui-env \
  ubuntu-xfce-vnc

   Opcions que hem trobat:
   - Podeu canviar els ports mapejant a altres ports locals
   - Podeu afegir -e VNC_PASSWORD=noupassword per canviar contrasenya
   - Podeu mapejar directoris amb -v /ruta/local:/app

3. CONNECTAR-SE VIA VNC:
   - Adreça: localhost:5901
   - Contrasenya: password (per defecte)

4. CONNECTAR-SE VIA SSH:
   ssh -p 2222 root@localhost
   Contrasenya: password (per defecte)

5. DINS DEL CONTENIDOR:
   - L'entorn XFCE estarà disponible via VNC
   - Visual Studio Code es pot iniciar des del terminal amb 'code'
   - Python 3 està instal·lat i preparat per utilitzar

## SCRIPT D'ATURADA
----------------
Per aturar i netejar el contenidor, executeu:
sudo ./stop_container.sh

Aquest script ofereix:
1. Atura el contenidor en execució
2. Elimina el contenidor
3. Opció per eliminar la imatge Docker
4. Neteja recursos no utilitzats

## NOTES IMPORTANTS
----------------
- Les contrasenyes per defecte són "password" (entorns reals l'hauriem de canviar)
- El servidor SSH genera noves claus cada vegada que s'inicia el contenidor
- Per accés SSH sense warnings, executeu:
  ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:2222"

## PROBLEMES CONEGUTS
------------------
1. Advertència SSH sobre host key changed:
   És normal en entorns de desenvolupament. Solució:
   ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:2222"

2. L'entorn gràfic pot trigar uns segons en estar disponible després
   d'iniciar el contenidor.

## AJUDA I CONTACTE
----------------
Per qualsevol dubte o problema, contacteu amb:
- Roger Domingo: roger.domingo.7e7@itb.cat
- Iker Blazquez: iker.blazquez.7e7@itb.cat

Versió: 6.0 - Data: 8/05/2025