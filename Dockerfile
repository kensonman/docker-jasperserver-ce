# Date:   2018-02-22 14:46
# Author: Kenson Man
# File:   Dockerfile
# Desc:   The file used to create the jasperserver's container-image with Docker(C) technology.
# Usage:  
#      docker build -t jasperserver-ce:latest .
# Binary: You can also download the related container image from [Docker Hub](https://hub.docker.com/r/kensonman/jasperserver-ce/)
FROM tomcat:8

ENV TARGET="TIB_js-jrs-cp_7.1.0_linux_x86_64.run"

COPY scripts/entrypoint /
COPY scripts/${TARGET}.arguments /tmp/${TARGET}.arguments
COPY resources/${TARGET} /tmp/${TARGET}

RUN chmod +x /tmp/${TARGET} /entrypoint \
&&  /tmp/${TRAGET} < /tmp/${TARGET}.arguments \
&&  rm /tmp/${TARGET}*

# Set default environment options.
ENV JAVA_OPTS="${JAVA_OPTIONS:--Xms1024m -Xmx2048 -Xss2m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled} -Djs.license.directory=${JRS_LICENSE:-/usr/local/share/jasperreports-pro/license}"

# Expose ports. Note that you must do one of the following:
# map them to local ports at container runtime via "-p 8080:8080 -p 8443:8443"
# or use dynamic ports.
EXPOSE ${HTTP_PORT:-8080} ${HTTPS_PORT:-8443}

ENTRYPOINT ["/entrypoint"]

# Default action executed by entrypoint script.
CMD ["run"]
