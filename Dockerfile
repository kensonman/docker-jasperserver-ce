# Date:   2018-02-22 14:46
# Author: Kenson Man
# File:   Dockerfile
# Desc:   The file used to create the jasperserver's container-image with Docker(C) technology.
# Usage:  
#      docker build -t jasperserver-ce:latest .
# Binary: You can also download the related container image from [Docker Hub](https://hub.docker.com/r/kensonman/jasperserver-ce/)
FROM tomcat:8

ENV TARGET="TIB_js-jrs-cp_7.1.0_linux_x86_64.run"
ENV CATALINA_HOME="/usr/local/tomcat"
ENV TOMCAT_ADMIN="admin"
ENV TOMCAT_PASS="efGCEHa4VqGSfkqJ"
# Set default environment options.
ENV JAVA_OPTS="${JAVA_OPTIONS:--Xms1024m -Xmx2048m -Xss2m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled}"

COPY scripts/entrypoint /
COPY scripts/${TARGET}.arguments /tmp/${TARGET}.arguments
COPY resources/${TARGET} /tmp/${TARGET}

#Install
RUN chmod +x /tmp/${TARGET} /entrypoint \
&&  ls -l /tmp/ \
&&  cat /tmp/${TARGET}.arguments | /tmp/${TARGET} \
&&  sed -i '43a<role rolename="manager-gui"/>' /usr/local/tomcat/conf/tomcat-users.xml \
&&  sed -i "44a<user username=\"${TOMCAT_ADMIN}\" password=\"${TOMCAT_PASS}\"/>" /usr/local/tomcat/conf/tomcat-users.xml \
&&  sed -i "20s:.*:allow=\"localhost\"/>:g" ${CATALINA_HOME}/webapps/manager/META-INF/context.xml \
&&  echo "Tomcat Admin: ${TOMCAT_ADMIN}::${TOMCAT_PASS}"

#Remove installer and migrate the jasper-server webapps as ROOT
RUN rm /tmp/${TARGET}* \
&&  rm -rf ${CATALINA_HOME}/webapps/ROOT \
&&  mv ${CATALINA_HOME}/webapps/jasperserver ${CATALINA_HOME}/webapps/ROOT 


# Expose ports. Note that you must do one of the following:
# map them to local ports at container runtime via "-p 8080:8080 -p 8443:8443"
# or use dynamic ports.
EXPOSE ${HTTP_PORT:-8080} ${HTTPS_PORT:-8443}

ENTRYPOINT ["/entrypoint"]

# Default action executed by entrypoint script.
CMD ["run"]
