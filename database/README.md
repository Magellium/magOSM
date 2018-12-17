# Mise en place d'une base de données PostgreSQL/PostGIS mise à jour quotidiennement avec Osm2pgsql et Osmosis

## Sources utiles
* http://www.volkerschatz.com/net/osm/osm2pgsql-usage.html
* https://wiki.openstreetmap.org/wiki/Osm2pgsql
* https://github.com/openstreetmap/osm2pgsql/blob/master/docs/usage.md
* https://wiki.openstreetmap.org/wiki/HowTo_minutely_hstore
* https://switch2osm.org/loading-osm-data/

## Version des logiciels utilisés
* PostgreSQL 9.6.3
* Postgis 2.3.2
* Osm2pgsql 0.92.0
* Osmosis 0.45
* Osmium version 1.5.1 - libosmium version 2.11.0

## Mise en place de la BD

~~~~
$ sudo su - postgres
~~~~
~~~~
$ cat <<'EOF' | psql -U postgres 
    /* Création des utilisateurs "magosm" et "isogeo" */
    CREATE ROLE magosm LOGIN
        NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
    CREATE ROLE isogeo LOGIN
        NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
    /* Création de la BD "magosm" */
    CREATE DATABASE magosm
        WITH OWNER = magosm
            ENCODING = 'UTF8'
            TABLESPACE = pg_default
            LC_COLLATE = 'en_US.UTF-8'
            LC_CTYPE = 'en_US.UTF-8'
            CONNECTION LIMIT = -1;
EOF
~~~~
~~~~
$ cat <<'EOF' | psql -d magosm -U postgres
    /* Création des extensions utiles */
    CREATE EXTENSION postgis;
    CREATE EXTENSION hstore;
    CREATE EXTENSION btree_gist;
EOF
~~~~
~~~~
$ cat <<'EOF' | psql -d magosm -U magosm
    /* Création du schéma "magosm" pour l'import des données OSM et les vues thématiques */
    CREATE SCHEMA magosm
        AUTHORIZATION magosm;
    GRANT ALL ON SCHEMA magosm TO magosm;
    GRANT USAGE ON SCHEMA magosm TO isogeo;
    /* Modification du "search_path" de l'utilisateur isogeo pour les scans FME */
    ALTER ROLE isogeo IN DATABASE magosm
    SET search_path = "$user", public, magosm;
EOF
~~~~

**Remarque** : si on veut importer les données dans un schéma portant un *$nom_schema* différent du nom de l'utilisateur principal (ici "magosm"), il faut modifier le search_path de l'utilisateur en conséquent : `ALTER ROLE magosm IN DATABASE magosm SET search_path = $nom_schema, "$user", public;`

## Import initial des données France

    #On travaille dans un répertoire /data
    $ mkdir /data /data/up-to-date /data/up-to-date/nodes_cache

    #Téléchargement de la donnée France
    $  wget http://download.geofabrik.de/europe/france-latest.osm.pbf /data/france-latest.osm.pbf

    #Import dans la BD depuis le container
    #Les paramètres --cache et --number-processes sont à personnaliser selon les caractéristiques du serveur
    $ osm2pgsql --create -H *$HOST* -U magosm -d magosm -W --slim --flat-nodes /data/up-to-date/nodes_cache/nodes.cache --cache 4000 --number-processes 6 --extra-attributes --hstore  --multi-geometry -p 'france' --style /*$magosm_public_git_repo*/database/magosm.style /data/france-latest.osm.pbf

## Maintien à jour

### Configuration Osmosis
Sources : https://github.com/springmeyer/up-to-date/blob/master/how_to.txt

    # Initialisation Osmosis (crée 2 fichiers download.lock et configuration.txt)
    $ osmosis --read-replication-interval-init workingDirectory=/data/up-to-date
        
    # Retrouver le timestamp du fichier .osm.pbf utilisé lors de l'import initial
	$ osmium fileinfo -e --progress -v /data/france-latest.osm.pbf
	    # exemple de résultat :
		#osmosis_replication_base_url=http://download.geofabrik.de/europe/france-updates
		#osmosis_replication_sequence_number=1553
		#osmosis_replication_timestamp=2018-06-19T20:43:13Z
    		
    # Créer un fichier /data/up-to-date/state.txt avec les informations de réplication Osmosis 
    # (on soustrait 24 heures au timestamp fourni par Osmosis pour ne rater aucun fichier de changement)
    # Exemple de fichier state.txt :
    	timestamp=2017-06-18T20\:43\:13Z
    	sequenceNumber=1552

    # Modifier le fichier configuration.txt généré par Osmosis pour pointer vers GeoFabrik et régler l'intervalle à 24h (86400s)
    # Contenu de /data/up-to-date/configuration.txt
    	baseUrl=http://download.geofabrik.de/europe/france-updates/
    	maxInterval= 86400
    	
### Procédure pour une mise à jour manuelle
Cette procédure permet de mettre à jour la base d'un état initial au jour J vers le jour J+1.
Pour mettre à jour la BD, il faut répéter ces 2 commandes autant de fois qu'il y a de jours à rattraper depuis l'import initial, soit à la main soit via un cron (cf la section "Automatisation" ci-dessous)

    # Téléchargement des changements
    $ mkdir /data/up-to-date/diffs
    $ osmosis --read-replication-interval workingDirectory=/data/up-to-date --simplify-change --write-xml-change /data/up-to-date/diffs/changes.osc.gz

    # Import des changements
	$ osm2pgsql --append -H *$HOST* -U magosm -d magosm -W --slim --flat-nodes /data/up-to-date/nodes_cache/nodes.cache --cache 4000 --number-processes 6 --extra-attributes --hstore  --multi-geometry -p 'france' --style /*$magosm_public_git_repo*/database/magosm.style /data/up-to-date/diffs/changes.osc.gz

### Automatisation

    #Création d'un dossier pour les logs du script keepup.sh
    $ mkdir /data/up-to-date/keepup-cron-logs/

**Création d'un script /data/up-to-date/keepup.sh**

	#!/bin/bash
	# source : https://github.com/springmeyer/up-to-date/blob/master/how_to.txt

	# make sure osmososis/osm2pgsql are on your PATH
	# cron does not inherit from your env
	export PATH=/usr/bin/:$PATH
	DBNAME=magosm
	DBUSER=magosm
	HOST='$HOST'
	DIR=/data/up-to-date

	# lock file
	LOCK=$DIR/keepup.lock

	cd $DIR

	if [ -f $LOCK ]; then
	  if [ "$(ps -p `cat $LOCK` | wc -l)" -gt 1 ]; then
		echo "Locked"
		exit 1
	  else
		rm $LOCK
	  fi
	fi
	echo $$ >$LOCK
	OSM_CHANGE=diffs/latest.osc.gz
	rm $OSM_CHANGE
	osmosis --read-replication-interval workingDirectory=. --simplify-change  --write-xml-change $OSM_CHANGE
	osm2pgsql --append -H $HOST -U $DBUSER -d $DBNAME --slim --flat-nodes ./nodes_cache/ --cache 4000 --number-processes 6 --extra-attributes --hstore  --multi-geometry -p 'france' --style /*$magosm_public_git_repo*/database/magosm.style  $OSM_CHANGE
	rm $LOCK

**Mettre en place un fichier de mot de passe**

https://www.postgresql.org/docs/current/static/libpq-pgpass.html

**Mise en place du cron**

    0  1   *   *   * /data/up-to-date/keepup.sh > /data/up-to-date/keepup-cron-logs/keepup-cron.log 2>&1

**Création des views**

    $ cat /*$magosm_public_git_repo*/database/views/views-useful-indexes.sql | psql -d magosm -U magosm
    $ cat /*$magosm_public_git_repo*/database/views/france*.sql | psql -d magosm -U magosm

