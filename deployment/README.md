# Déployer l'application

Une fois l'application installée et configurée pour la première fois (
voir [la procédure d'installation](../INSTALL.md)), le déploiement des nouvelles versions se fait en suivant la
procédure ci-dessous.

## Déployer les sources sur le serveur cible

Le script `scripts/deploy-sources-to-server.sh` permet de synchroniser le répertoire du projet avec un serveur distant
en ignorant les fichiers inutiles (voir `scripts/rsync-exclusions`). Le fichier `.env` est exclu de la synchronisation pour préserver la configuration de la plateforme cible.
Il prend en entrée l'utilisateur et l'hôte du serveur cible :

```bash
cd deployment
#le répertoire /path/to/dest doit exister et l'absence de "/" final est nécessaire
scripts/deploy-sources-to-server.sh user@host:/path/to/dest
```

**Le reste de la procédure de déploiement a lieu sur le serveur distant.**

* Démarrer les services

Le script `scripts/start-services.sh` permet de construire les images docker et lancer les services
```bash
scripts/start-services.sh
```
