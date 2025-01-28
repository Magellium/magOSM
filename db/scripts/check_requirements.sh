#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed

# Source env file
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../deployment/.env


echo
echo ------------------------------------------------------
echo Check requirements
echo

## Check if docker is installed
if ! [ -x "$(command -v docker)" ]
then
  echo 'Error: docker is not installed.' >&2
  exit 1
else
  echo '- Docker is installed.' >&2
fi

## Check for a base working dir
if [ ! -d "$HOST_VOLUMES_BASE_DIR" ]
then
    >&2 echo -e "Error: '$HOST_VOLUMES_BASE_DIR' base directory does not exist. You could run:\n\
    mkdir -p $HOST_VOLUMES_BASE_DIR"
    exit 1
else
  echo "- '$HOST_VOLUMES_BASE_DIR' base directory exists.">&2
fi

## Check for some working dir
DIR="$OSMOSIS_OSM2PGSQL_WORKING_DIR $OSMOSIS_OSM2PGSQL_LOG_DIR $OSMOSIS_WORKING_DIR $PG_DATA_DIR $OSM_PBF_FILES_DIR"
MISSING_DIR=""
for dir in $DIR
do
if [ ! -d "$HOST_VOLUMES_BASE_DIR/$dir" ]
then
    MISSING_DIR="$MISSING_DIR $HOST_VOLUMES_BASE_DIR/$dir"
    >&2 echo -e "Error: '$HOST_VOLUMES_BASE_DIR/$dir' directory does not exist."
else
  echo "- '$dir' directory exists.">&2
fi
done

if [ ! -z "$MISSING_DIR" ]; then
    echo -e "At least one working directory is missing. You could run:\n\
    mkdir -p $MISSING_DIR"
    exit 1
fi

## Check for the latest .osm.pbf file
if [ ! -f "$HOST_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME" ]
then
    >&2 echo -e "Error: '$HOST_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME' file does not exist."
    if [ ! -z "$OSM_LATEST_PBF_FILE_DOWNLOAD_URL" ]; then
    echo -e "You could run:\n\
    wget $OSM_LATEST_PBF_FILE_DOWNLOAD_URL -O $HOST_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME"
    fi
    exit 1
else
  echo "- '$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME' file exists">&2
fi

## Check for the replication tree
if ! curl --head --fail --silent "$OSM_REPLICATION_TREE_BASE_URL/state.txt" >/dev/null
then
    >&2 echo "Error: replication tree is not reachable (no file behind URL '$OSM_REPLICATION_TREE_BASE_URL/state.txt')"
    exit 1
else
  echo -e "- replication tree is reachable: $OSM_REPLICATION_TREE_BASE_URL, \n\
  here is the last state.txt file:" >&2
  curl -s $OSM_REPLICATION_TREE_BASE_URL/state.txt
fi

