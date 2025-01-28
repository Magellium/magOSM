#!/usr/bin/env bash

set -o errexit
here=$(dirname "$0")
cd "$here/../.."

target=$1

if [[ -z $target ]];then
  echo "Usage: $0 user@host:/path/to/dest"
  exit 1
fi;

target_server=$(echo "$target" | cut -d':' -f1)
target_dir=$(echo "$target" | cut -d':' -f2)

read -r -p "La synchronisation va se faire sur le serveur $target_server répertoire $target_dir. S'agit-il du bon serveur ? Entrée pour oui, Ctrl-C pour non."

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
           ./ $target

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
           ./ $target
echo "✅  Sources synchronisées"

