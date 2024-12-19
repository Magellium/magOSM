#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR
#set -x # Print commands and their arguments as they are executed

## Config reading
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  $here/../../conf/.env

echo "test env var"
echo "magosm user $DBPG_USER_MAGOSM_USERNAME"

echo
echo ------------------------------------------------------
echo Create USER $DBPG_USER_MAGOSM_USERNAME if not exists
echo

psql -U postgres $PSQL_CONOPTS -a << EOF
DO
\$do\$
BEGIN
    IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = '$DBPG_USER_MAGOSM_USERNAME'
    )
    THEN
      CREATE ROLE $DBPG_USER_MAGOSM_USERNAME LOGIN PASSWORD '$DBPG_USER_MAGOSM_PWD' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
   END IF;
END
\$do\$;
EOF

echo
echo ------------------------------------------------------
echo Create DB $DBPG_DATABASE_NAME if not exists with extensions
echo

psql -U postgres $PSQL_CONOPTS -tc "SELECT 1 FROM pg_database WHERE datname='$DBPG_DATABASE_NAME';" | grep -q 1 || psql -U postgres $PSQL_CONOPTS -a << EOF
CREATE DATABASE $DBPG_DATABASE_NAME
    WITH OWNER = $DBPG_USER_MAGOSM_USERNAME
        ENCODING = 'UTF8'
        TABLESPACE = pg_default
        LC_COLLATE = 'en_US.utf8'
        LC_CTYPE = 'en_US.utf8'
        CONNECTION LIMIT = -1
EOF

psql -U postgres $PSQL_CONOPTS -d $DBPG_DATABASE_NAME -a << EOF
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS pltcl;
EOF

echo
echo ------------------------------------------------------
echo CREATE SCHEMA $DBPG_SCHEMA_MAGOSM_NAME
echo

psql -U postgres $PSQL_CONOPTS -d $DBPG_DATABASE_NAME -a << EOF
-- DROP SCHEMA IF EXISTS $DBPG_SCHEMA_MAGOSM_NAME CASCADE;
CREATE SCHEMA $DBPG_SCHEMA_MAGOSM_NAME
    AUTHORIZATION $DBPG_USER_MAGOSM_USERNAME;
GRANT ALL ON SCHEMA $DBPG_SCHEMA_MAGOSM_NAME TO $DBPG_USER_MAGOSM_USERNAME;
EOF

echo
echo ------------------------------------------------------
echo ALTER DATABASE $DBPG_DATABASE_NAME DEFAULT search_path
echo

psql -U postgres $PSQL_CONOPTS -d $DBPG_DATABASE_NAME -a << EOF
    ALTER DATABASE $DBPG_DATABASE_NAME SET search_path TO $DBPG_SCHEMA_MAGOSM_NAME, public;
EOF