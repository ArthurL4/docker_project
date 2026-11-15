# Projet 3DOKR

## Participants
- Arthur Leroux
- Baptiste Menet


## Composition

Le projet contient l'arborescence suivante:
- `./`
	- `net/`
	-  `node/`
	-  `postgreSQL/`
	-  `python/`
	-  `redis/`
	-  `swarm`
- `.env`
- `docker-compose.yaml`
-  `README.md`

## Exécution

Le projet se lance depuis la racine avec la commande `docker compose up --build`, qui exécute le fichier `docker-compose.yaml`.

Les dossiers `net/`, `node/`, `postgreSQL/`, `python/` et `redis` correspondent chacun à un service du `docker-compose.yaml`. Chaque dossier dispose de son fichier `Dockerfile` ainsi que du dossier contenant le code du service associé. Les fichiers `.info` sont des métadonnées à titre d'information et n'ont pas d'utilité.

Les deux services exposés sont respectivement `result` qui appartient au dossier `node/`, il écoute sur le port 3000 et le service `vote`, appartenant au dossier `python/` qui écoute sur le port 5000.

A cet égard, nous avons modifié dans le code les ports dans le fichier `server.js`:
```javascript
const  port  =  3000
```

dans `app.py`:

```python
if  __name__  ==  "__main__":

app.run(host='0.0.0.0', port=5000, debug=True, threaded=True)
```

et nous avons également changé dans les différents fichiers source le domain sur les noms des services pour permettre la résolution DNS de Docker.

```python
Flask.redis = Redis(host="redis-backend", db=0, socket_timeout=5)
```

````javascript
const  pool  =  new  pg.Pool({

connectionString:  "postgres://postgres:postgres@postgres-backend/postgres",

})
````

````csharp
var  pgsql  =  OpenDbConnection("Server=postgres-backend;Username=postgres;Password=postgres;");

var  redisConn  =  OpenRedisConnection("redis-backend");
````
````csharp
pgsql  =  OpenDbConnection("Server=postgres-backend;Username=postgres;Password=postgres;");
````

Le fichier .env sert à définir les valeurs des placeholders dans notre fichier docker-compose.yaml.

Nous définissons notamment:
- NETWORK_BACKEND=backend
- NETWORK_FRONTEND=frontend

mais également l'emplacement du mot de passe pour `postgres` qui se trouve à POSTGRES_PASSWORD=./postgreSQL/postgres-passwd

````yaml
secrets:
	postgres.passwd:
		file: ${POSTGRES_PASSWORD}
````


Les ports côté hôte sont les mêmes que pour les services `result` et `vote`,  ils sont accessibles depuis localhost:3000 et localhost:5000 en http.

Chaque service de base SQL ou NoSQL disposent d'un volume qui lui est propre:

````yaml
volumes:
	redis_volume:
	postgres_volume:
````


Concernant le service python, nous avons utilisé l'utilitaire`uv`, aussi le fichier `requirements.txt` a été remplacé au profit d'un fichier `pyproject.toml` qui permet une approche plus moderner de l'usage de python.

Cela nous a permis également de produire notamment pour le service `worker` et `vote` des fichiers `Dockerfile` multistage.


## Docker Swarm 

Concernant la partie `swarm`, le projet dispose d'un dossier `swarm`:

- `./swarm/`
	- `docker-compose.yaml`
	- `init.bat`
	- `Vagrantfile`

En se déplaçant dans le dossier `swarm/` il est possible d'exécuter `./init.bat` pour déployer le `swarm` depuis un environnement `Windows` disposant de `WSL2`et de `Oracle VirtualBox`. 

Le fichier `init.bat` exécute séquentiellement les actions requises au déploiement du `swarm`.

Le dossier dispose de son propre fichier `docker-compose.yaml`, **IL N EST EN AUCUN CAS A UTILISER AVEC** `docker-compose up --build`. Ce fichier est propre à `docker swarm` et n'a aucune correspondance avec le fichier `.env` vu précédemment également.

Cela étant dit, afin de le faire à la main, il convient de suivre les étapes suivantes:

- Se déplacer dans le dossier `swarm`
- Lancer la commande `vagrant up`, celle-ci lance le script ruby dans Vagrantfile pour préparer les machines virtuelles (`winget install -e --id Hashicorp.Vagrant` pour installer vagrant sur windows si il n'est pas présent)
- Attendre la création des machines virtuelles
- Se connecter au manager avec la commande `vagrant ssh manager1` et exécuter la commande `docker swarm init --advertise-addr 192.168.99.100` dans la machine virtuelle du `manager1`
- Copier le token qui est fourni par le `manager1`pour se connecter à son cluster.
- Quitter le `manager1`avec `exit`
- Se connecter respectivement sur chacun des workers avec `vagrant ssh worker1`, puis `vagrant ssh worker2` et exécuter la commande  `docker swarm join --token %TOKEN% 192.168.99.100:2377`, %TOKEN% étant celui que vous avez préalablement copié durant la phase avec `manager1` afin de se connecter au cluster.
- Vérifier l'état du cluster en se connectant sur `vagrant ssh manager1` puis `docker node ls`.
- A partir de là, il y a deux solutions, soit vous utilisez `docker context` pour créer un `context` de connexion à `manager1` à travers `ssh`: => `docker context create context_manager --docker "host=ssh://vagrant@192.168.99.100"`. Cela implique de disposer du client `OpenSSH`, de charger la clé privée pour `manager1` avec `ssh-add path/to/secreyKey`, clé que vous pouvez retrouver grâce à `vagrant ssh-config manager1`. Soit vous vous connectez sur `vagrant ssh manager1`, puis `worker1`, puis `worker2` et vous lancez les commandes pour construire chaque images avant de déployer la stack depuis `manager1`.

````bash
docker build -t redis:1.0.0 /project/redis/
docker build -t postgres:1.0.0 /project/postgreSQL/
docker build -t result:1.0.0 /project/node/
docker build -t vote:1.0.0 /project/python/
docker build -t worker:1.0.0 /project/net/
````

Lors  de la création des machines virtuelles Vagrant enregistre le projet sous `/project` dans chaque VM:

````ruby
config.vm.synced_folder  "../", "/project"
````

Autrement dit, vous pouvez accéder au projet depuis l'environnement de la VM sans passer par `docker context` depuis la machine hôte.
 - Si vous utilisez `docker context use context_manager` et que vous vous connectez en `SSH`, alors vous pouvez directement utiliser la commande suivante: `docker stack deploy -c ./docker-compose.yaml project` **à condition d'avoir bien build les images avant de chaque services**.
 - Sinon, il vous faut donc créer les images dans chaque VM comme indiqué précédemment puis ensuite lancer  `docker stack deploy -c /project/swarm/docker-compose.yaml project` depuis `manager1`.


Une solution élégante serait de créer des dépôts sur `docker hub` afin d'y stocker nos images Docker, puis de les récupérer depuis chacune des machines virtuelles à l'aide de la commande suivante : `docker pull monrepo/monimage:1.0.0` pour éviter de créer les images dans chaque VM à chaque fois.







