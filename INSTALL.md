# Installation

## Pré-requis serveur

Testé avec :

* Debian 12 - Docker version 27.0.3, build 7d4bcd8 - rootless install - voir [Run the Docker daemon as a non-root user (Rootless mode)](https://docs.docker.com/engine/security/rootless/#prerequisites)
* Ubuntu 22.04 - Docker version 27.0.3, build 7d4bcd8 - as a non-root user - voir [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)

Le reste de la doc d'install est réalisée avec un utilisateur `debian` non sudoer.

## Synchroniser les sources

* S'assurer d'être propriétaire des fichiers
  Se placer à la racine du projet et exécuter la commande suivante
```bash
sudo chown -R $UID:$GID .
```

* Synchroniser les sources:
Le script `deployment/scripts/deploy-sources-to-server.sh` permet de prévisualiser puis d'effectuer la synchronisation des sources.
Il prend en argument le host du serveur ainsi que le répertoire de destination
```bash
deployment/scripts/deploy-sources-to-server.sh user@target-server-host:/path/to/dest
```
**Le reste de la procédure d'installation a lieu sur le serveur distant.**
* Créer le réseau docker `magosm` 
```bash
docker network create magosm
```
## Base de données

Se placer à la racine du projet sur le serveur cible.

### Adapter la configuration de la base de données

Les fichiers suivants contiennent entre autre la configuration par défaut de la base de données:

- `env/default.env` : contient les variables d'environnement nécessaires au build des images et à l'exécution des
  containers, notamment celui de la db. Il est situé en dehors de la racine pour éviter un parasitage entre
  fichiers `.env`.
- `db/conf/postgres_settings_default.sh`: contient un script qui met à jour la configuration postgres

* créer les fichiers de configuration à partir des fichiers par défaut:

```bash
cp ./env/default.env ./deployment/.env
cp db/conf/postgres_settings_default.sh db/conf/postgres_settings.sh
```

* Modifier les fichiers `./deployment/.env` et `db/conf/postgres_settings.sh` créés précédemment afin qu'ils contiennent
  la configuration voulue pour le projet
  ⚠️ Portez une attention particulière aux variables suivantes : 

````bash
#contient le mot de passe de l'utilisateur postgres pour la db
DBPG_USER_POSTGRES_PWD
#contient le mot de masse de l'utilisateur magosm pour la db
DBPG_USER_MAGOSM_PWD

#contient l'uid / gid souhaitée à l'intérieur du container
GEOSERVER_UID=
GEOSERVER_GID=
#contient l'uid / gid du propriétaire souhaité du volume data_dir sur la machine 
GEOSERVER_VOLUME_HOST_OWNER_UID=
GEOSERVER_VOLUME_HOST_OWNER_GID=
````

### Construire l'image docker

* exécuter le script suivant et suivre les instructions jusqu'à ce qu'il n'affiche plus d'erreurs :

```bash
db/scripts/check_requirements.sh
```

* construire l'image docker:

```bash
cd deployment
docker compose build db
```

### Configurer la db

* Démarrer la db:

```bash
docker compose up db -d
```

* Injecter les variables d'environnement dans le shell courant (à répéter à chaque changement de shell)

```bash
source .env
```

* Appliquer la configuration postgres

```bash
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/conf/postgres_settings.sh
# check your pg_hba.conf is correct
docker compose exec db bash -c 'cat ${PGDATA}/pg_hba.conf'
# you must restart your container to restart postgres service (needed for parameters which require a restart to update, as `shared_buffers`)
docker compose restart db
# you can check that your postgresql.conf file has been correctly edited
docker compose exec db bash -c 'cat ${PGDATA}/postgresql.conf'
```

* Créer les utilisateurs et la base de données

```bash
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/init_db.sh
```

* Importer les données du fichier pbf dans la base

```bash
# prepare command
CMD="osm2pgsql \
--create \
$OSM2PGSQL_OPTS \
$DOCKER_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME"
# check it
echo $CMD
# run
docker compose exec db $CMD >> $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/osm2pgsql-create.log 2>&1
# check log file
tail -f -n 200 $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/osm2pgsql-create.log
```

* Créer les vues

```bash
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/init_views.sh
# look for errors
docker compose exec db sh -c 'grep ERR /tmp/*log.err'
```

* Créer les tables, triggers et fonctions pour magosm-change :

```bash
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/init_magosm-change.sh
```

### Configurer Osmosis

* Vérifier l'existence et la conformité du state file (suivre les instructions du script) :

```bash
cd ../db
bash ./scripts/database/check_osmosis_state_file.sh
```

* Initialiser le répertoire de travail Osmosis

```bash
bash ./scripts/database/init_osmosis_working_dir.sh
```

* Effectuer une mise à jour manuelle

```bash
cd ../deployment
# osmosis/osm2pgsql update  + change analysis (`changes_analysis_*` tables are only populated on second iteration)
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/keepup_osm_db_and_changes.sh >> $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_db_and_changes.log 2>&1
# check log file
tail -f -n 200 $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_db_and_changes.log
# then check that your state.txt is one day later
cat $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_WORKING_DIR/updates/state.txt
```

```bash
#  materialized views update
docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/keepup_osm_views.sh >> $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_views.log 2>&1
# check log file
tail -f -n 200 $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_views.log
```

* Ajouter les tâches cron

```bash
# compléter avec le chemin absolu vers le répertoire deployment (deployment compris)
export MAGOSM_COMPOSE_PROJECT_DIR=
sudo bash -c "cat <<EOF > /etc/cron.d/keepup_docker-db
# osmosis/osm2pgsql update 
30 10 * * * debian docker compose -f $MAGOSM_COMPOSE_PROJECT_DIR exec  --project-dir $MAGOSM_COMPOSE_PROJECT_DIR db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/keepup_osm_db_and_changes.sh > $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_db_and_changes.log 2>&1 && docker compose exec db bash $DOCKER_VOLUMES_BASE_DIR/$SOURCE_DIR/scripts/database/keepup_osm_views.sh > $HOST_VOLUMES_BASE_DIR/$OSMOSIS_OSM2PGSQL_LOG_DIR/keepup_osm_views.log 2>&1
EOF"
```


## Configurer geoserver

### Démarrer le service une première fois

⚠️ Les identifiants de connexion de l'interface d'administration de geoserver sont ceux par défaut.
La procédure de changement du mot de passe d'administration Geoserver est détaillée plus bas.
* Si ce n'est pas déjà fait, créer le réseau docker `magosm`
```bash
docker network create magosm
```
* Démarrer geoserver et le reverse-proxy

```bash
docker compose up -d geoserver reverse-proxy
```

* Attendre que geoserver soit démarré

```bash
#geoserver service must be marked as healthy
docker compose ps
```

### Gestion des instances multiples

Le nombre de containers geoserver déployés est indiqué dans le fichier `deployment/docker-compose.yml`. La valeur
associée est celle indiquée dans `geoserver > deploy > replicas`.
Docker gère ainsi le load balancing entre les différentes instances de geoserver déployées.
Cependant, il n'est pas possible d'accéder à l'interface d'administration de geoserver lorsque plusieurs containers du
service `geoserver` sont lancés en même temps (les requêtes d'authentification et d'accès aux données ne sont pas
adressées à un même container).

Pour contourner ce problème, on peut procéder de la manière suivante:

* arrêter les containers avec `docker stop` et pas `docker compose stop` jusqu'à ce qu'il n'en reste qu'un en marche:
Par exemple, si `replicas: 2`:

```bash
docker stop $COMPOSE_PROJECT_NAME-geoserver-2
```

Si on dispose d'un environnement de travail sur la machine cible, on peut ensuite se connecter à l'interface administrateur via `http://localhost:81/geoserver`

* lorsqu'on a fini d'utiliser l'interface administrateur, relancer tous les containers

```bash
#relance les autres containers avec la configuration actualisée
docker compose up geoserver -d
#redémarre le container actuel avec la configuration actualisée (optionnel, nécessaire uniquement si on a fait une modification qui nécessite un redémarrage du container)
docker restart $COMPOSE_PROJECT_NAME-geoserver-1
```

### Changer les identifiants de connexion à l'interface administrateur

* Suivre la procédure ci-dessus pour n'avoir qu'un seul container geoserver en marche
* Se rendre dans l'interface administrateur de geoserver via `http://localhost:81/geoserver`  et se connecter avec les
  identifiants par défaut : `admin`/`geoserver`.
* Dans le menu aller dans `Sécurité > Utilisateurs, Groupes et Rôles` puis cliquer sur l'onglet "Utilisateurs/Groupes"
* Cliquer sur l'utilisateur `admin` et modifier le mot de passe puis sauvegarder

### Changer le mot de passe de connexion à la base de données

* Depuis l'interface d'administration de geoserver, se rendre dans `Entrepôts > magosm`
* Dans les identifiants de connexion, indiquer le mot de passe précédemment choisi pour l'utilisateur `magosm` de la
  base de données (correspond à `DBPG_USER_MAGOSM_PWD` dans le fichier `.env`) puis sauvegarder
* Répéter l'opération pour `Entrepôts > citymap`

## Démarrer le reste des services

* Construire les images docker manquantes

```bash
docker compose build client services-webapp
```

* Démarrer les services

```bash
docker compose up -d
```

On peut ensuite vérifier le statut des services avec `docker compose ps`