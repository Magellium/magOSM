#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed


# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../../deployment/.env

## Check for state.txt

echo -e "\n\
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\
    !!!WARNING: OSMOSIS WILL NEED A state.txt FILE !!!\n\
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\
    \n\
    WHAT IS A state.txt FILE ?
    \n\
    The state.txt file contains information about the version (sequenceNumber) \n\
    and the timestamp of the osm/pbf file and you need to get the state.txt \n\
    file that corresponds to the dataset you downloaded. \n\
    \n\
    HOW TO GET ONE ?
    \n\
    To be sure to don't miss any change: you can chose a  \n\
    state.txt file corresponding to one or two days before .osm.pbf file timestamp. \n\
    \n\
    1) check your file timestamp by running: \n\
    docker compose exec db  osmium fileinfo -e -g data.timestamp.last $DOCKER_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME \n\
    \n\
    2) find the good state.txt file at $OSM_REPLICATION_TREE_BASE_URL \n\
    (if the state.txt file corresponding to your timestamp is 422.state.tx, take 421.state.txt) \n\
    \n\
    3) download it: \n\
    wget {URL_PATH_TO_STATE_FILE} -O $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt \n\
    \n\
    --
    \n\
    Note: if you've downloaded the latest .osm.pbf file and just want to use the latest state.txt, just run: \n\
    wget $OSM_REPLICATION_TREE_BASE_URL/state.txt -O $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt \n\
    \n\
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n\
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n\
    "
echo
echo

if [ ! -f "$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt" ]
then
    >&2 echo -e "Error: '$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt' file does not exist. Check above how to get one."
    echo
    echo
    exit 1
else
  echo -e "- '$HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt' file exists, check if it's correct:">&2
  echo
  echo -e "Timestamp of your $OSM_LATEST_PBF_FILE_NAME (be patient, it could take some minutes):"
  echo "---"
  ( cd $here/../../../deployment/ && docker compose exec db  osmium fileinfo -e -g data.timestamp.last $DOCKER_VOLUMES_BASE_DIR/$OSM_PBF_FILES_DIR/$OSM_LATEST_PBF_FILE_NAME)
  echo "---"
  echo
  echo -e "Your state.txt file (timestamp should be older than the timestamp of your $OSM_LATEST_PBF_FILE_NAME)"
  echo "---"
  cat $HOST_VOLUMES_BASE_DIR/$OSMOSIS_WORKING_DIR/state.txt
  echo "---"
  echo 
  echo
fi