#!/bin/bash

usage() { echo "Usage: $0 [-n mysql_container_name] [-u <usuaro_bd>] [-p <password_bd>] [-d <database>]" 1>&2; exit 1; }
[ $# -eq 0 ] && usage

while getopts ":u:c:p:d:h:" opt; do
  case $opt in
    c )
      CONTAINER_NAME=$OPTARG
      ;;
    u )
      DBUSER=$OPTARG
      ;;
    p )
      PASSWORD=$OPTARG
      ;;
    h )
      DBHOST=$OPTARG
      ;;
    d )
      DB=$OPTARG
      ;;
    : )
      echo "Opcion -$OPTARG require un argumento." >&2
      exit 1
      ;;
    * )
      echo "Opcion inválida o sin argumentos: -$OPTARG" >&2
      echo
      usage
      exit 2
      ;;
  esac
done
shift $((OPTIND-1))

if [ ! "$CONTAINER_NAME" ] && [ ! "$DBHOST" ] || [ ! "$PASSWORD" ] || [ ! "$DBUSER" ] || [ ! "$DB" ]
then
    echo "Faltan parámetros requeridos."
    usage
    exit 1
fi

FECHA=$(date  +'%Y%m%d_%H%M%S')
DIAS_MAXIMOS=45
BACKUPS_ROOT=${1:-/root/backups}

if [ "$DBHOST" ]
then
    IP=$DBHOST
else
    IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_NAME)
fi

if [ ! "$IP" ]
then 
    echo "Container '$CONTAINER_NAME' no encontrado."
    exit 4
fi

# purgamos os vellos
find $BACKUPS_ROOT -mtime +$DIAS_MAXIMOS -exec rm -f '{}' +

#backups
mysqldump --opt --triggers --routines -u ${DBUSER} -p${PASSWORD} -h $IP ${DB} | gzip > ${BACKUPS_ROOT}/${DB}_${FECHA}.sql.gz
