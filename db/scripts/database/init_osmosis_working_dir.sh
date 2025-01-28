#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed

# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../../deployment/.env

echo
echo ------------------------------------------------------
echo CREATE 'changes' DIRECTORY FOR .osc.gz FILES UNDER $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR
echo

mkdir -p $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/changes

echo
echo ------------------------------------------------------
echo OSMOSIS: INIT WITH 'osmosis --read-replication-interval-init' 
echo

CONFIG_FILE=$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/configuration.txt
if [ ! -f "$CONFIG_FILE" ]
then
   ( cd $here/../../../deployment && docker compose exec db osmosis --read-replication-interval-init workingDirectory=$DOCKER_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR)
else
    >&2 echo "Error: '$CONFIG_FILE' file already exist"
    exit 1
fi


echo
echo ------------------------------------------------------
echo OSMOSIS: UPDATE configuration.txt
echo

echo
echo 'DEFAULT configuration.txt VERSION:'
echo -------
cat $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/configuration.txt
echo -------
echo

sed -i "s!baseUrl=https://planet.openstreetmap.org/replication/minute\
!baseUrl=$OSM_REPLICATION_TREE_BASE_URL!" \
$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/configuration.txt

sed -i "s!maxInterval = 3600\
!maxInterval = $OSMOSIS_MAX_INTERVAL!" \
$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/configuration.txt

echo
echo 'UPDATED configuration.txt VERSION:'
echo -------
cat $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/configuration.txt
echo -------
echo
echo