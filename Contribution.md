Si vous pensez qu'une thématique manque, n'hésitez pas à [nous contacter](https://magosm.magellium.com/) pour en discuter !<br>
Chaque nouvelle thématique consomme des ressources sur le serveur de magOSM, nous essayons donc de privilégier des thématiques utiles au plus grand nombre.

# Proposer une nouvelle couche thématique

Pour enrichir le service d'une nouvelle couche de données sur une thématique, les étapes suivantes sont nécessaires:
* Ouvrir un pad collaboratif ([Framapad](https://framapad.org/fr/) ou équivalent) 
* Y renseigner 3 sections :
  * *requête PGSQL* correspondant à la thématique
  * *style SLD* qui sera utilisé par défaut pour le format WMS
  * *fiche de métadonnées* (le titre et la description suffisent)
* Nous vérifions/testons vos ajouts sur le serveur
* Vous réalisez une Pull Request sur le dépôt Github afin que votre contribution soit intégrée

## Définir la requête SQL

### Introduction
La base de données magOSM est basée sur Osm2pgsql qui crée notamment 3 tables d'exploitation dans le schéma magosm :
* magosm.france_point
* magosm.france_line
* magosm.france_polygon

Pour créer une nouvelle thématique dans magOSM il faut commencer par créer une "vue" PGSQL.<br>
Il est possible de s'inspirer d'une [requête existante](database/views) proche de votre thématique.

### Syntaxe de requête pour les tags

**Généralités**<br>
Lors de l'import de la donnée OSM dans la base de données PGSQL à l'aide de Osm2pgsql, les attributs (tags) les plus "fréquents" sont importés dans des colonnes dédiées (ex : l'attribut "name"), et les moins fréquents sont tous relégués dans une colonne "tags" de type [hstore](https://www.postgresql.org/docs/9.0/hstore.html) qui est une succession d'associations clé/valeur.<br>

Exemple de contenu de la colonne  tags :<br>
```{"colour"=>"#dda0dd", "network"=>"Agglobus Cavem", "osm_uid"=>"0", "osm_user"=>"", "route_name"=>"11: Les Deux Collines => Lycée Camus", "osm_version"=>"66", "osm_changeset"=>"0", "osm_timestamp"=>"2018-11-22T17:53:42Z", "route_pref_color"=>"0", "public_transport:version"=>"2"}```.

1. pour récupérer un attribut "fréquent" il suffit de faire un ```SELECT tag_frequent```<br>
Exemple : ```SELECT name FROM magosm.france_line WHERE ...```
2. alors que pour récupérer un attribut "moins fréquent", il faut faire un ```SELECT tags->'tag_peu_frequent' AS "tag_peu_frequent"```<br>
Exemple : ```SELECT tags->'network' AS "network" FROM magosm.france_line WHERE ...```

La liste des attributs "fréquents" est définie par le style [magosm.style](database/magosm.style ) utilisé par Osm2pgsql pour l'import. Si la clé de l'attribut d'intérêt n'est pas listé dans le fichier magosm.style, c'est qu'il se trouvera dans la colonne tags de type hstore.

### Indexes
Pour des questions de performance, on s'assurera qu'un index est déjà défini pour la colonne de filtrage correspondant à la thématique (exemple : la colonne "building" pour les bâtiments) : vérifiez dans [la liste des index existants](database/views/views-useful-indexes.sql)

### Attributs avec cacatères spéciaux
On adopte la convention suivante : si la clé de l'attribut utilisé contient le caractère deux-points " :  "  (exemple : ```public_transport:version```) alors on remplacera le ":" par un tiret "-" dans l'alias, exemple : 
* pour un tag "fréquent" : ```SELECT "addr:housename" AS "addr-housename"```
* pour un tag "peu fréquent" : ```SELECT tags->'public_transport:version' AS "public_transport-version"```


### Relations
Les objets OSM de type "relation" sont également disponibles dans les tables france_line et france_polygon, avec un osm_id négatif égal à l'opposé de l'identifiant de la relation dans OSM (exemple : la ligne de bus [11: Les Deux Collines => Lycée Camus (8937340)](https://www.openstreetmap.org/relation/8937340/) est présente sous forme d'une multi-ligne dans la table france_line avec ```osm_id=-8937340```).<br>
C'est pourquoi pour la thématique des lignes de bus on requête sur ```osm_id<0``` : [france_bus_routes_line.sql](database/views/france_bus_routes_line.sql)<br>
Et la ligne de bus est consultable via le portail magOSM [ici](http://magosm.magellium.com/portail/#/carte?z=14&lon=6.6595&lat=43.4217&tr=30&vLay=france_bus_routes_line).<br>
Dans le cas où l'on voudrait également récuper la liste des arrêts de bus (nodes) associés à la relation, la liste complète des identifiants des membres de la relation est disponible dans la table france_rels et les objets nodes se trouvent dans la table france_point.

## Définir le style SLD
S'inspirer d'un style existant. Exemple de styles simples :
* géométrie Point : [france_police_point.sld](styles/france_police_point.sld)
* géométrie Ligne : [france_subway_routes_line.sld](styles/france_subway_routes_line.sld)
* géométrie Polygone : [france_pnr_polygon.sld](styles/france_pnr_polygon.sld)


## Rédiger la fiche de métadonnées
Se limiter aux champs "Titre" et "Résumé".<br>
Exemples pour :
* une requête dans la table "point" et "polygone" avec calcul du centroïd : [Localisations des brigades de gendarmeries et commissariats de police - France métropolitaine.xml](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80/r/ff7980650742460aaba2075d6cc69e58)
* une requête dans la table "line" avec osm_id>0 : [Réseau routier - France métropolitaine](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80/r/62af719c4df84359b6b465105241476f)
* une requête dans la table "line" avec osm_id<0 : [Autoroutes - France métropolitaine](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80/r/bf7507c1a2b545ec941c98dbe02d6b0c)
* une requête dans la table "polygon" : [Parcs Naturels Régionaux - France métropolitaine](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80/r/a3b4c3fea4234b769083983c57db4d2e)

## Pull request
Pour réaliser une pull request via l'interface Web de Github :
* Forker le dépôt magOSM via le [bouton en haut à droite](https://github.com/magellium/magosm) afin de créer une copie personnelle du dépôt de code magOSM
* Dans votre nouveau dépôt personnel :
  * Ajout de la requête SQL dans un nouveau fichier ici : [/database/views](database/views)
  * Ajout de l’index ici :  [/database/views/views-useful-indexes.sql](database/views/views-useful-indexes.sql)
  * Ajout du style SLD dans un nouveau fichier ici : [/styles](styles)
  * Ajout de la fiche de métadonnées dans un nouveau fichier ici : [/metadatas](metadatas)
  * Nous
* [Créer une pull request depuis votre fork](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)
