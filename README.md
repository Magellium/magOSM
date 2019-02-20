## magOSM
Toutes les informations utiles sur le projet sont accessibles directement sur le site de magOSM  : https://magosm.magellium.com/

## Contribuer

### Améliorer la carte
Les données diffusées par le projet magOSM sont toutes issues de la base de données géographique OpenStreetMap (OSM).<br>
OpenStreetMap est un projet de cartographie qui a pour but de constituer une base de données géographiques libre du monde.
Le projet est souvent désigné comme "le Wikipédia de la cartographie".<br>
Tout le monde peut participer à améliorer la carte en ajoutant ou en mettant à jour des données ! Plus d'informations ici :<br>
* <a href="https://www.openstreetmap.org/user/new" target="_blank">Se créer un compte</a>
* <a href="https://learnosm.org/fr/" target="_blank">LearnOSM</a>
* <a href="https://www.openstreetmap.fr/" target="_blank">Association OpenStreetMap France</a>

### Remonter une anomalie ou proposer une amélioration
Vous pouvez [rapporter une anomalie](https://github.com/magellium/magosm/issues/new). Merci de fournir autant de détails que possible (copies d'écran, étapes pour reproduire etc.).

### Proposer une nouvelle couche thématique
Un guide est disponible ici : [Contribution.md](Contribution.md) !

## Organisation du dépot
 * portail/client : code source du [Portail magOSM](http://magosm.magellium.com/portail/)
 * metadatas : fiches de métadonnées du [Catalogue magOSM](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80) au format XML ISO 19139
 * database : déploiement d'une base de données PostgreSQL/PostGIS mise à jour quotidiennement avec Osm2pgsql et Osmosis & requêtes PGSQL de créations des vues thématiques
 * styles : fichiers de style SLD définissant les styles par défaut pour les flux WMS
