#!/bin/bash

# Settings
#######
# Be sure we fail on error and output debugging information
set -e
trap 'echo "$0: error on line $LINENO"' ERR
# Print commands and their arguments as they are executed
#set -x
#######

# Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../../conf/.env

while getopts s:u:d: option
do
	case "${option}"
		in
        s) PG_SCHEMA=${OPTARG};;
        u) PG_USER=${OPTARG};;
        d) PG_DATABASE=${OPTARG};;
	esac
done

echo
echo ------------------------------------------------------
echo ALTER ALL TABLES AND PROC IN DATABASE $PG_DATABASE SCHEMA $PG_SCHEMA OWNER TO $PG_USER
echo

# change tables owner
for tbl in `psql -U postgres $PSQL_CONOPTS -qAt -c "SELECT tablename FROM pg_tables WHERE schemaname = '$PG_SCHEMA';" $PG_DATABASE` ; 
do  psql -U postgres $PSQL_CONOPTS -c "ALTER TABLE $PG_SCHEMA.\"$tbl\" OWNER TO $PG_USER" $PG_DATABASE ; 
done

# change procedures owner
for proc in `psql -U postgres $PSQL_CONOPTS -qAt -c "SELECT proname FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid WHERE n.nspname IN ('$PG_SCHEMA');;" $DBPGDATABASE` ; 
do  psql -U postgres $PSQL_CONOPTS -c "ALTER FUNCTION $PG_SCHEMA.\"$proc\" OWNER TO $PG_USER" $PG_DATABASE ; 
done