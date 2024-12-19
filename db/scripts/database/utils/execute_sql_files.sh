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

while getopts f:p: option
do
	case "${option}"
		in
        p) PATH_TO_FILES=${OPTARG};;
		f) FILES=${OPTARG};;
	esac
done

echo
echo ------------------------------------------------------
echo EXECUTE SQL FILES
echo

echo FILES ARRAY:
echo $FILES

for file in $FILES
do
    sql_file="$PATH_TO_FILES/$file"
    log_file="$file"
    echo $sql_file
    if [ -f $sql_file ]
    then
        CMD="psql -U $DBPG_USER_MAGOSM_USERNAME $PSQL_CONOPTS -a -b -e -v ON_ERROR_STOP=1 -o /tmp/$log_file.log -f $sql_file 2> /tmp/$log_file.log.err"
        echo
        echo $CMD
        echo
        eval $CMD
        RET=$?
        if [ $RET -ne 0 ]; then
            echo "ERROR: pgsql exited with code $RET on $sql_file"
            echo "ERROR: pgsql exited with code $RET on $sql_file" >&2
            echo "ERROR: pgsql exited with code $RET on $sql_file" >> /tmp/$log_file.log
            echo "ERROR: pgsql exited with code $RET on $sql_file" >> /tmp/$log_file.log.err
            exit $RET;
        fi
        echo
        date
    else
        >&2 echo "ERROR: $sql_file file does not exist"
        exit 1
    fi
done

exit 0