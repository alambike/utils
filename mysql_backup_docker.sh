#!/bin/bash

while getopts h:d:u:p:b: opts; do
   case ${opts} in
      h) MYSQL_HOST=${OPTARG:-localhost} ;;
      d) MYSQL_DB=${OPTARG} ;;
      u) MYSQL_USER=${OPTARG:-root} ;;
      p) MYSQL_PASSWORD=${OPTARG} ;;
      b) BACKUPS_DIR=${OPTARG:-/root/backups} ;;
   esac
done

FECHA=$(date  +'%Y%m%d_%H%M%S')
IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MYSQL_HOST)
DIAS_MAXIMOS=45

# purgamos os vellos
find $BACKUPS_DIR -mtime +$DIAS_MAXIMOS -exec rm -f '{}' +

#backups
mysqldump --opt --triggers --routines -u $MYSQL_USER -p$MYSQL_PASSWORD -h $IP $MYSQL_DB | gzip > ${BACKUPS_DIR}/${MYSQL_DB}_$FECHA.sql.gz
