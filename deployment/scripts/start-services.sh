#!/usr/bin/env bash

set -o errexit
here=$(dirname "$0")
cd "$here/.."

source .env

echo "Construction des images docker"
docker compose build client services-webapp

echo "✅ Images docker construites"

echo "Arrêt des containers actuels"
docker compose down
echo "✅ Containers actuels arrêtés"

echo "Démarrage des services"
docker compose up -d

echo "Modification des permissions pour le data_dir geoserver"
uid=${UID}
gid=$(id -g)

sudo chown -R "$uid:$gid" ../geoserver/data_dir

echo "✅ Services démarrés, vous pouvez surveiller leur statut avec docker compose ps"