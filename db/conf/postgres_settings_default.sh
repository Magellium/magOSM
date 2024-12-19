#!/bin/bash

# Settings
set -e # Be sure we fail on error and output debugging information
trap 'echo "$0: error on line $LINENO"' ERR

echo
echo ------------------------------------------------------
echo Set PGSQL settings
echo

# postgres settings (compatible with postgres 13):
# - uncomment and set wanted parameters
# - [help] the command `sed -i -e"s/^shared_buffers = 128MB.*$/shared_buffers = 4GB/" ${PGDATA}/postgresql.conf`
#   will update "shared_buffers" parameter from "128MB" (default) to "4GB" in postgresql.conf file
# the recommended settings are taken from here: https://osm2pgsql.org/doc/manual.html#preparing-the-database

set -x # Print commands and their arguments as they are executed
sed -i -e"s/^max_connections = 100.*$/max_connections = 200/" ${PGDATA}/postgresql.conf
sed -i -e"s/^shared_buffers = 128MB.*$/shared_buffers = 1GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#work_mem = 4MB.*$/work_mem = 50MB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#maintenance_work_mem = 64MB.*$/maintenance_work_mem = 2GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#autovacuum_work_mem = -1.*$/autovacuum_work_mem = -1/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#wal_level = replica.*$/wal_level = minimal/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#max_wal_senders = 10.*$/max_wal_senders = 0/" ${PGDATA}/postgresql.conf
sed -i -e"s/^max_wal_size = 1GB.*$/max_wal_size = 10GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#checkpoint_timeout = 5min.*$/checkpoint_timeout = 60min/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#effective_cache_size = 4GB.*$/effective_cache_size = 10GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#wal_buffers = -1.*$/wal_buffers = -1/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#checkpoint_completion_target = 0.9.*$/checkpoint_completion_target = 0.9/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#random_page_cost = 4.0.*$/random_page_cost = 1.0/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#cpu_tuple_cost = 0.01.*$/cpu_tuple_cost = 0.05/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#autovacuum_vacuum_scale_factor = 0.2.*$/autovacuum_vacuum_scale_factor = 0.2/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#logging_collector = off.*$/logging_collector = on/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_directory = 'log'.*$/log_directory = 'log'/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'.*$/log_filename = 'postgresql-%a.log'/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_truncate_on_rotation = off.*$/log_truncate_on_rotation = on/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_rotation_age = 1d.*$/log_rotation_age = 1d/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_rotation_size = 10MB.*$/log_rotation_size = 0/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#log_line_prefix = '%m [%p] '.*$/log_line_prefix = '%m [%p] '/" ${PGDATA}/postgresql.conf
sed -i -e"s/^log_timezone = 'Etc\/UTC'.*$/log_timezone = 'UTC'/" ${PGDATA}/postgresql.conf
sed -i -e"s/^timezone = 'Etc\/UTC'.*$/timezone = 'UTC'/" ${PGDATA}/postgresql.conf