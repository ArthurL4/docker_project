REM On execute le fichier Vagrantfile qui se trouve dans le dossier courant
REM Cela init 3 VM avec VirtualBox
REM 192.168.99.100 / 192.168.99.101 / 192.168.99.102
vagrant up

REM On affiche le status des VM
vagrant status

REM On se co en SSH et on init le swarm sur l'ip du manager et on stocker le resultat dans un fichier token.txt   https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/set_1?utm_source=chatgpt.com
vagrant ssh manager1 -c "docker swarm init --advertise-addr 192.168.99.100"
vagrant ssh manager1 -c "docker swarm join-token --quiet worker" > token.txt
set /p TOKEN=<token.txt
echo TOKEN=%TOKEN%

REM On va associer les autres VM au cluster mtn puisqu'on a le token dans TOKEN 
REM 2377 c'est le port par défaut pour docker swarm our les join --> check ss a dans une VM *:2377
REM on co les deux VM en tant que node du cluster
vagrant ssh worker1 -c "docker swarm join --token %TOKEN% 192.168.99.100:2377"
vagrant ssh worker2 -c "docker swarm join --token %TOKEN% 192.168.99.100:2377"

REM on verifie mtn que tous les noeuds sont dispos depuis la machine hôtes
vagrant ssh manager1 -c "docker node ls"

REM on cree toutes les images pour pouvoir les lancer dans le cluster
vagrant ssh manager1 -c "docker build -t redis:1.0.0 /project/redis/"
vagrant ssh manager1 -c "docker build -t postgres:1.0.0 /project/postgreSQL/"
vagrant ssh manager1 -c "docker build -t result:1.0.0 /project/node/"
vagrant ssh manager1 -c "docker build -t vote:1.0.0 /project/python/"
vagrant ssh manager1 -c "docker build -t worker:1.0.0 /project/net/"


REM enfin on lancer notre docker-compose.yaml
vagrant ssh manager1 -c "docker stack deploy -c /project/swarm/docker-compose.yaml project"


