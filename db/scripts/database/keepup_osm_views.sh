#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed

# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../conf/.env

export PATH=/usr/bin/:$PATH

SCRIPT_NAME=`basename "$0"`

echo
echo "##############################################################################################################################################"
echo `date`: running \'${SCRIPT_NAME}\'
echo "##############################################################################################################################################"
echo

# initialize $SECONDS to mesure script execution time
SECONDS=0

echo
echo ------------------------------------------------------
echo RefreshAllMaterializedViews
echo

psql -U $DBPG_USER_MAGOSM_USERNAME -d $DBPG_DATABASE_NAME << EOF
SELECT RefreshAllMaterializedViews('$DBPG_SCHEMA_MAGOSM_NAME');
EOF

# mesure script execution time
duration=$SECONDS

echo
echo "##############################################################################################################################################"
echo `date`: ${SCRIPT_NAME} completed in
echo "$(($duration / 3600)) hour(s) $(($duration / 60)) minute(s) $(($duration % 60)) second(s)."
echo "##############################################################################################################################################"
echo