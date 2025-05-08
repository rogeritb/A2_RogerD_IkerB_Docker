# README - Entorn GUI amb XFCE, VNC i SSH en Docker
-------------------------------------------------

## Descripcio
----------
Aquest projecte crea un entorn grafic Ubuntu 24.04 amb escriptori XFCE accessible via VNC i SSH, ideal per a desenvolupament amb Python i Visual Studio Code.

## Caracteristiques
---------------
- Escriptori XFCE complet
- Acces remot via VNC (Remmina) i SSH
- Python 3 preinstal·lat
- Visual Studio Code integrat
- Configuracio segura per defecte

## Instal·lacio
-----------
1. Clona el repositori:
   git clone [URL_DEL_REPO]
   cd [DIRECTORI_DEL_PROJECTE]

2. Dona permisos d'execucio:
   chmod +x start_container.sh stop_container.sh set_vnc_password.exp

3. Construeix la imatge:
   sudo ./start_container.sh

## Acces
-----
VNC (Remmina):
- Adreça: localhost:5901
- Usuari: developer
- Contrasenya: developer

## SSH:
ssh -p 2222 developer@localhost
Contrasenya: developer

## Comandes Utils
-------------
- Aturar contenidor:
  sudo ./stop_container.sh
  
- Reiniciar serveis:
  docker exec asix-gui-container sudo service ssh restart

- Veure logs:
  docker logs asix-gui-container

## Notes Importants
---------------
- Els ports 5901 (VNC) i 2222 (SSH) han d'estar lliures
- El contenidor consumeix recursos significatius de CPU/RAM

Llicencia
--------
Aquest projecte s'ofereix sota llicencia MIT.

Contacte
-------
- Roger Domingo (roger.domingo.7e7@itb.cat) & Iker Blazquez (iker.blazquez.7e7@itb.cat)
- ASIXcC - ITB

Estructura de Fitxers
--------------------
projecte/
 Dockerfile                # Configuracio principal del contenidor
 start_container.sh        # Script d'inici
 stop_container.sh         # Script aturada
 set_vnc_password.exp      # Configuracio contrasenya VNC
 README.md                # Aquest document

Requisits
---------
- Docker instal·lat
- 2GB+ de RAM lliure
- Connexio a Internet per descarregar paquets