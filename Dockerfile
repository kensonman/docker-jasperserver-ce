# Date:   2018-02-22 14:46
# Author: Kenson Man
# File:   Dockerfile
# Desc:   The file used to create the jasperserver's container-image with Docker(C) technology.
# Usage:  
#      docker build -t jasperserver-ce:latest .
# Binary: You can also download the related container image from [Docker Hub](https://hub.docker.com/r/kensonman/jasperserver-ce/)
FROM tomcat:8

# Prepare and install the jasperserver
COPY resources/*.zip resources/extract.py /tmp/
RUN apt-get update && apt-get install -y postgresql-client unzip xmlstarlet libpostgresql-jdbc-java \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/jasperreports-server \
  && python /tmp/extract.py /tmp/ /usr/src/jasperreports-server \
  && cp /usr/src/jasperreports-server/buildomatic/sample_conf/postgresql_master.properties /usr/src/jasperresports-server/buildomatic/default_master.properties \
  && sed -i '46s/^/# /g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && sed -i '47s/^.*/appServerDir = \/usr\/local\/tomcat/g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && sed -i 's/dbHost=localhost/dbHost=${DBHOST:-dbhost}/g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && sed -i 's/dbPort=5432/dbPort=${DBPORT:-5432}/g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && sed -i 's/dbUsername=postgres/dbUsername=${DBUSER:-postgres}/g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && sed -i 's/dbPassword=postgres/dbPassword=${DBPASS:-postgres}/g' /usr/src/jasperreports-server/buildomatic/default_master.properties \
  && mkdir -p /usr/local/share/jasperresports-pro/license \
  && /usr/src/jasperreports-server/buildomatic/js-install.sh \
  && rm -rf /tmp/*

# Extract phantomjs, move to /usr/local/share/phantomjs, link to /usr/local/bin.
# Comment out if phantomjs not required.
RUN wget \
    "https://bitbucket.org/ariya/phantomjs/downloads/\
phantomjs-2.1.1-linux-x86_64.tar.bz2" \
    -O /tmp/phantomjs.tar.bz2 --no-verbose && \
    tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp && \
    rm -f /tmp/phantomjs.tar.bz2 && \
    mv /tmp/phantomjs*linux-x86_64 /usr/local/share/phantomjs && \
    ln -sf /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin && \
    rm -rf /tmp/*
# In case you wish to download from a different location you can manually
# download the archive and copy from resources/ at build time. Note that you
# also # need to comment out the preceding RUN command
#COPY resources/phantomjs*bz2 /tmp/phantomjs.tar.bz2
#RUN tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp && \
#    rm -f /tmp/phantomjs.tar.bz2 && \
#    mv /tmp/phantomjs*linux-x86_64 /usr/local/share/phantomjs && \
#    ln -sf /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin && \
#    rm -rf /tmp/*

# Set default environment options.
ENV JAVA_OPTS="${JAVA_OPTIONS:--Xms1024m -Xmx2048 -Xss2m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled} -Djs.license.directory=${JRS_LICENSE:-/usr/local/share/jasperreports-pro/license}"

# Configure tomcat for SSL (optional). Uncomment ENV and RUN to enable generation of
# self-signed certificate and to set up JasperReports Server to use HTTPS only.
#
#ENV DN_HOSTNAME=${DN_HOSTNAME:-localhost.localdomain} \
#    KS_PASSWORD=${KS_PASSWORD:-changeit} \
#    JRS_HTTPS_ONLY=${JRS_HTTPS_ONLY:-true} \
#    HTTPS_PORT=${HTTPS_PORT:-8443}
#
#RUN keytool -genkey -alias self_signed -dname "CN=${DN_HOSTNAME}" \
#        -keyalg RSA -storepass "${KS_PASSWORD}" \
#        -keypass "${KS_PASSWORD}" \
#        -keystore /root/.keystore && \
#    xmlstarlet ed --inplace --subnode "/Server/Service" --type elem \
#        -n Connector -v "" --var connector-ssl '$prev' \
#    --insert '$connector-ssl' --type attr -n port -v "${HTTPS_PORT:-8443}" \
#    --insert '$connector-ssl' --type attr -n protocol -v \
#        "org.apache.coyote.http11.Http11NioProtocol" \
#    --insert '$connector-ssl' --type attr -n maxThreads -v "150" \
#    --insert '$connector-ssl' --type attr -n SSLEnabled -v "true" \
#    --insert '$connector-ssl' --type attr -n scheme -v "https" \
#    --insert '$connector-ssl' --type attr -n secure -v "true" \
#    --insert '$connector-ssl' --type attr -n clientAuth -v "false" \
#    --insert '$connector-ssl' --type attr -n sslProtocol -v "TLS" \
#    --insert '$connector-ssl' --type attr -n keystorePass \
#        -v "${KS_PASSWORD}"\
#    --insert '$connector-ssl' --type attr -n keystoreFile \
#        -v "/root/.keystore" \
#    ${CATALINA_HOME}/conf/server.xml

# Expose ports. Note that you must do one of the following:
# map them to local ports at container runtime via "-p 8080:8080 -p 8443:8443"
# or use dynamic ports.
EXPOSE ${HTTP_PORT:-8080} ${HTTPS_PORT:-8443}

COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Default action executed by entrypoint script.
CMD ["run"]
