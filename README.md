# magOSM

Toutes les informations utiles sur le projet sont accessibles directement sur le site de magOSM  : https://magosm.magellium.com/

## Contribuer

### Améliorer la carte

Les données diffusées par le projet magOSM sont toutes issues de la base de données géographique OpenStreetMap (OSM).<br>
OpenStreetMap est un projet de cartographie qui a pour but de constituer une base de données géographiques libre du monde.
Le projet est souvent désigné comme "le Wikipédia de la cartographie".<br>
Tout le monde peut participer à améliorer la carte en ajoutant ou en mettant à jour des données ! Plus d'informations ici :

* [Se créer un compte](https://www.openstreetmap.org/user/new)
* [LearnOSM](https://learnosm.org/fr/)
* [Association OpenStreetMap France](https://www.openstreetmap.fr/)

### Remonter une anomalie ou proposer une amélioration

Si vous voulez rapporter une anomalie sur le portail magOSM, ou bien proposer une amélioration, vous pouvez [ouvrir une issue](https://github.com/magellium/magosm/issues/new). Pour une anomalie, merci de fournir autant de détails que possible (copies d'écran, étapes pour reproduire etc.).

### Proposer une nouvelle couche thématique

Un guide est disponible ici : [Contribution.md](Contribution.md) !

## Organisation du projet

* `./portail/` : frontend et backend du [Portail magOSM](http://magosm.magellium.com/portail/)
* `./metadatas/` : fiches de métadonnées du [Catalogue magOSM](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80) au format XML ISO 19139
* `./styles/` : fichiers de style SLD définissant les styles par défaut pour les flux WMS
* [magosm_db](https://github.com/Magellium/magosm_db) : dépôt de code relatif à la base de données magOSM
