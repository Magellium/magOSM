#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
set -x # Print commands and their arguments as they are executed

# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../conf/.env

cd $here/../../pg_views/

echo
echo ------------------------------------------------------
echo CREATE INDEXES
echo

pg_useful_indexes_file=(ind_*)
/bin/bash $here/utils/execute_sql_files.sh -p $(pwd) -f "$(printf "%s "  "${pg_useful_indexes_file[@]}")"

echo
echo ------------------------------------------------------
echo CREATE PLPGSQL FUNCTION
echo

pg_proc_files=(proc_*)
/bin/bash $here/utils/execute_sql_files.sh -p $(pwd) -f "$(printf "%s "  "${pg_proc_files[@]}")"

echo
echo ------------------------------------------------------
echo CREATE VIEWS
echo

pg_views_files=(v_*)
/bin/bash $here/utils/execute_sql_files.sh -p $(pwd) -f "$(printf "%s "  "${pg_views_files[@]}")"



#echo
#echo ------------------------------------------------------
#echo ALTER OWNER
#echo

#/bin/bash $here/utils/alter_pgsql_tables-proc_owner.sh \
#-s $DBPG_SCHEMA_MAGOSM_NAME \
#-u $DBPG_USER_MAGOSM_USERNAME \
#-d $DBPG_DATABASE_NAME