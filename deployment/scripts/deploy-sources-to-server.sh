#!/usr/bin/env bash

set -o errexit
here=$(dirname "$0")
cd "$here/../.."

target_dir=$1

if [[ -z $target_dir ]];then
  echo "Usage: $0 user@host:/path/to/dest"
  exit 1
fi;

read -r -p "La synchronisation va se faire sur le serveur / répertoire $target_dir. S'agit-il du bon serveur ? Entrée pour oui, Ctrl-C pour non."

echo "La synchronisation des sources qui sera effectuée entre le dossier local et le serveur après confirmation :"
rsync --dry-run \
           --checksum \
           --recursive \
           --delete \
           --compress \
           --progress \
           --itemize-changes \
           --human-readable \
           --verbose \
           --exclude-from='deployment/scripts/rsync-exclusions' \
           ./ $target_dir

read -r -p "Confirmez-vous la synchronisation de ces sources ? Entrée pour oui ou Ctrl+C sinon "

echo "Synchronisation des sources en cours"

rsync      --checksum \
           --recursive \
           --delete \
           --compress \
           --progress \
           --itemize-changes \
           --human-readable \
           --verbose \
           --exclude-from='deployment/scripts/rsync-exclusions' \
           ./ $target_dir
echo "✅  Sources synchronisées"

