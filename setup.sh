#!/bin/bash
# Create Bidirectional SSH Keys for pgBackrest and Postgres

set -u

PGSQL='./services/postgres/config'
BACKREST='./services/pgbackrest/config'

if [[ -f ${PGSQL?}/postgres ]]
then
    rm -f ${PGSQL?}/postgres
    rm -f ${PGSQL?}/postgres.pub
fi

if [[ -f ${BACKREST?}/backrest ]]
then
    rm -f ${BACKREST?}/backrest
    rm -f ${BACKREST?}/backrest.pub
fi

ssh-keygen -b 2048 -t rsa -f ${PGSQL?}/postgres -q -N ""
ssh-keygen -b 2048 -t rsa -f ${BACKREST?}/backrest -q -N ""

cat ${PGSQL?}/postgres.pub > ${BACKREST?}/authorized_keys
cat ${BACKREST?}/backrest.pub > ${PGSQL?}/authorized_keys

exit 0
