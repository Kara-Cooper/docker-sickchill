FROM lsiobase/python:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SICKCHILL_TAG
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="homerr"

# set python to use utf-8 rather than ascii
ENV PYTHONIOENCODING="UTF-8"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade && \
 apk add --no-cache \
	git \
	jq \
	nodejs && \
 echo "**** fetch sickchill ****" && \
 mkdir -p \
	/app/sickchill && \
 if [ -z ${SICKCHILL_TAG+x} ]; then \
	SICKCHILL_TAG=$(curl -sX GET https://api.github.com/repos/SickChill/SickChill/tags \
	| jq -r 'first(.[]) | .name'); \
 fi && \
 echo "found ${SICKCHILL_TAG}" && \
 git clone https://github.com/SickChill/SickChill.git /app/sickchill && \
 cd /app/sickchill && \
 git checkout ${SICKCHILL_TAG}

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8081
VOLUME /config
