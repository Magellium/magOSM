## A propos de magOSM
magOSM propose d’accéder à des jeux de données thématiques issus d’OpenStreetMap aux formats WFS/WMS. 
Ces données sont mises à jour quotidiennement sur la France métropolitaine. Ce service permet ainsi d’accéder directement à des couches de données vectorielles sous QGIS ou tout autre environnement client de services OGC

## Rajouter une nouvelle thématique
Pour enrichir le service d'une nouvelle couche de données sur une thématique, les étapes suivantes sont nécessaires:
 1. Définir la requête SQL qui permet d'extraire les données des tables contenants les données brutes(france_line,france_point, france_polygon)
 2. Décrire la couche en créant une fiche de métadonnées pour qu'elle soit décrite et présentée dans un catalogue.
 3. Définir un style de représentation pour la diffusion des données au format image / WMS


## Organisation du dépot github magOSM

 * portail/client : code source du portail Angular http://magosm.magellium.com/portail/
 * metadatas : liste des fiches de métadonnées
 * database : scripts de création des vues et scripts d'initialisation de la base
 * styles : définition des symbologies dans un fichier excel et fichiers SLD correspondants

 





