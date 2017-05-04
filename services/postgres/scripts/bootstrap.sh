#!/bin/bash

USER='postgres'
GROUP='postgres'
PGSQL_VER='9.6'
PGSQL_SRC_DIR='/tmp/postgres'
PGSQL_DIR='/var/lib/pgsql'
COMMON_DIR='/tmp/common'
BIN_DIR="/usr/pgsql-${PGSQL_VER?}/bin"
PGDG='https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm'

yum install -y ${PGDG?} >/dev/null 2>&1

yum install -y postgresql96 \
               postgresql96-contrib \
               postgresql96-libs \
               postgresql96-server \
               postgresql96-docs \
               pgbackrest \
               >/dev/null 2>&1

/usr/pgsql-${PGSQL_VER?}/bin/postgresql96-setup initdb
systemctl enable postgresql-${PGSQL_VER?}

mkdir ${PGSQL_DIR?}/.ssh

cp ${PGSQL_SRC_DIR?}/config/pgbackrest.conf /etc/pgbackrest.conf
cp ${PGSQL_SRC_DIR?}/config/authorized_keys ${PGSQL_DIR?}/.ssh
cp ${PGSQL_SRC_DIR?}/config/config ${PGSQL_DIR?}/.ssh/config
cp ${PGSQL_SRC_DIR?}/config/postgres ${PGSQL_DIR?}/.ssh
cp ${PGSQL_SRC_DIR?}/config/postgresql.conf ${PGSQL_DIR?}/${PGSQL_VER?}/data
cp ${PGSQL_SRC_DIR?}/config/pg_hba.conf ${PGSQL_DIR?}/${PGSQL_VER?}/data

chown -R ${USER?}:${GROUP?} ${PGSQL_DIR?}
chmod 700 ${PGSQL_DIR?}/.ssh
chmod 600 ${PGSQL_DIR?}/.ssh/config
chmod 600 ${PGSQL_DIR?}/.ssh/authorized_keys
chmod 400 ${PGSQL_DIR?}/.ssh/postgres
chmod 600 ${PGSQL_DIR?}/${PGSQL_VER?}/data/postgresql.conf
chmod 600 ${PGSQL_DIR?}/${PGSQL_VER?}/data/pg_hba.conf
restorecon ${PGSQL_DIR?}/.ssh
restorecon ${PGSQL_DIR?}/.ssh/config
restorecon ${PGSQL_DIR?}/.ssh/authorized_keys

systemctl start postgresql-${PGSQL_VER?}

${COMMON_DIR?}/scripts/node_exporter_install.sh

su - postgres -c \
    "${BIN_DIR?}/psql -d postgres -f /tmp/postgres/scripts/statistics.sql"

${PGSQL_SRC_DIR?}/scripts/install_postgres_exporter.sh

exit 0
