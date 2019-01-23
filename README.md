## magOSM
Toutes les informations utiles sur le projet sont accessibles directement sur le site de magOSM  : https://magosm.magellium.com/

## Contribuer

### Remonter une anomalie ou proposer une amélioration
Vous pouvez [rapporter une anomalie](https://github.com/magellium/magosm/issues/new). Merci de fournir autant de détails que possible (copies d'écran, étapes pour reproduire etc.).

### Proposer une nouvelle couche thématique
Un guide est disponible ici : [Contribution.md](/blob/master/Contribution.md) !

## Organisation du dépot
 * portail/client : code source du [Portail magOSM](http://magosm.magellium.com/portail/)
 * metadatas : fiches de métadonnées du [Catalogue magOSM](http://open.isogeo.com/s/6da366a3991f4d42aa9d2a8f58a73af1/pHUOzxi2EayRSGnbHCbdZOXzQGN80) au format XML ISO 19139
 * database : déploiement d'une base de données PostgreSQL/PostGIS mise à jour quotidiennement avec Osm2pgsql et Osmosis & requêtes PGSQL de créations des vues thématiques
 * styles : fichiers de style SLD définissant les styles par défaut pour les flux WMS
