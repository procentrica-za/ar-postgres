#!/bin/bash

# create wso2 api manager databases
psql -f /sql/createdatabase.sql

# create wso2 api manager database tables
psql -d wso2mb_db -f /sql/postgresql-mb.sql
psql -d wso2am_db -f /sql/postgresql-am.sql
psql -d wso2carbon_db -f /sql/postgresql-carbon.sql
psql -d wso2metrics_db -f /sql/postgresql-metrics.sql
psql -d gregdb -f /sql/wso2-is-postgress.sql


set -e

psql -v ON_ERROR_STOP=1 --username "postgres" --dbname="ar" <<-EOSQL
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
EOSQL