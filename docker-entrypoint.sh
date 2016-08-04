#!/bin/sh

if [ "$(stat -c "%Y" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml")" -eq "0" ]; then
  if [ -n "${TOMCAT_PROXY_NAME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8090"]' --type "attr" --name "proxyName" --value "${TOMCAT_PROXY_NAME}" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"
  fi
  if [ -n "${TOMCAT_PROXY_PORT}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8090"]' --type "attr" --name "proxyPort" --value "${TOMCAT_PROXY_PORT}" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"
  fi
  if [ -n "${TOMCAT_PROXY_SCHEME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8090"]' --type "attr" --name "scheme" --value "${TOMCAT_PROXY_SCHEME}" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"
  fi
  if [ -n "${TOMCAT_PROXY_SECURE}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8090"]' --type "attr" --name "secure" --value "${TOMCAT_PROXY_SECURE}" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"
  fi
  if [ -n "${TOMCAT_CONTEXT_PATH}" ]; then
    xmlstarlet ed --inplace --pf --ps --update '//Context/@path' --value "${TOMCAT_CONTEXT_PATH}" "${CONFLUENCE_INSTALL_DIR}/conf/server.xml"
  fi
fi

if [ -n "${CONFLUENCE_LOGS_STDOUT}" ]; then
  ln -sf /dev/stdout ${CONFLUENCE_HOME_DIR}/logs/atlassian-confluence.log
fi

exec ${CONFLUENCE_INSTALL_DIR}/bin/catalina.sh run