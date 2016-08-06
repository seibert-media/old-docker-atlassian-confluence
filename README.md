# docker-atlassian-confluence

This is a Docker-Image for Atlassian Confluence based on [Alpine Linux](http://alpinelinux.org/), which is kept as small as possible.

## Features

* Small image size
* Setting proxy parameters in server.xml to run it behind a reverse proxy (TOMCAT_PROXY_* ENV)
* Redirecting application logs to stdout (CONFLUENCE_LOGS_STDOUT ENV)

## Getting started

Run confluence standalone and navigate to `http://[dockerhost]:8090` to finish configuration:

```bash
docker run --detach --publish 8090:8090 seibertmedia/atlassian-confluence:latest
```

Specify persistent volume for Confluence data directory and redirect application logs to stdout:

```bash
docker run -d -p 8090:8090 -v confluence_data:/var/opt/confluence -e CONFLUENCE_LOGS_STDOUT=1 seibertmedia/atlassian-confluence:latest
```

Run confluence behind a reverse SSL proxy like nginx and navigate to `https://wiki.yourdomain.com`:

```bash
docker run -d -p 8090:8090 -e TOMCAT_PROXY_NAME=wiki.yourdomain.com -e TOMCAT_PROXY_PORT=443 -e TOMCAT_PROXY_SCHEME=https seibertmedia/atlassian-confluence:latest
```