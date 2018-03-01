#!/bin/bash

# The src folder that contains all the buildomatic scripts.
# It should be configured by docker.
TRGDIR=${TRGDIR:-/usr/src/jasperreports-server}

# Sets script to fail if any command fails.
set -e

# If environment is not set, uses default values for postgres
DB_USER=${DBUSER:-postgres}
DB_PASSWORD=${DBPASS:-postgres}
DB_HOST=${DBHOST:-postgres}
DB_PORT=${DBPORT:-5432}
DB_NAME=${DBNAME:-jasperserver}
# Simple default_master.properties. Modify according to
# JasperReports Server documentation.
cat >/usr/src/jasperreports-server/buildomatic/default_master.properties\
<<-_EOL_
appServerType=tomcat8
appServerDir=$CATALINA_HOME
dbType=postgresql
dbHost=$DB_HOST
dbUsername=$DB_USER
dbPassword=$DB_PASSWORD
dbPort=$DB_PORT
js.dbName=$DB_NAME
_EOL_

install_jasperserver() {
   cd ${TRGDIR}/buildomatic/
   rm -rf $CATALINA_HOME/webapps/ROOT ;
   mkdir -p $CATALINA_HOME/webapps/ROOT ;
   unzip -o -q ${TRGDIR}/jasperserver.war -d $CATALINA_HOME/webapps/ROOT ;
   js-ant create-js-db init-js-db-pro import-minimal-pro
}

run_jasperserver() {
   if [ -d "$CATALINA_HOME/webapps/examples" ]; then
      install_jasperserver
   fi
  
   catalina.sh run
}

case "$1" in
  run)
    shift 1
    run_jasperserver "$@"
    ;;
  init)
    install_jasperserver "$@" 
    ;;
  *)
    exec "$@"
esac

