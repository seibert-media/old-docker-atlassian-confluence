FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ENV CONFLUENCE_VERSION       5.10.3
ENV CONFLUENCE_INSTALL_DIR   /opt/confluence
ENV CONFLUENCE_HOME_DIR 	 /var/opt/confluence

ENV MYSQL_VERSION 5.1.39
ENV MYSQL_DRIVER_DOWNLOAD_URL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz

RUN set -x \
	&& echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk update \
	&& apk add curl tar xmlstarlet@testing

RUN DL_PATH=https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz set -x \
 	&& mkdir -p ${CONFLUENCE_HOME_DIR}/logs \
 	&& chown -R daemon: ${CONFLUENCE_HOME_DIR} \
    && mkdir -p ${CONFLUENCE_INSTALL_DIR} \
    && cd ${CONFLUENCE_INSTALL_DIR} \
    && curl -Ls ${DL_PATH} | tar -xvz --strip-components=1 \
    && chown -R daemon: conf/ work/ logs/ temp/ \
    && echo "confluence.home = ${CONFLUENCE_HOME_DIR}" > ${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/classes/confluence-init.properties \
    && xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
                               "${CONFLUENCE_INSTALL_DIR}/conf/server.xml" \
    && touch -d "@0"           "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"

RUN set -x \
    && curl -Ls "${MYSQL_DRIVER_DOWNLOAD_URL}" | \
    tar -xvz --directory "${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/lib" --strip-components=1 --no-same-owner \
	"mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}-bin.jar"

USER daemon:daemon

EXPOSE 8090/tcp

VOLUME [${CONFLUENCE_HOME_DIR}]

WORKDIR ${CONFLUENCE_HOME_DIR}

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
