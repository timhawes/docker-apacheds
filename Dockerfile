FROM debian:jessie

ENV APACHEDS_VERSION 2.0.0-M21
ENV APACHEDS_MD5 489bbdf106ed1b44f54830d93db8aba2
ENV APACHEDS_GNUPG_KEY 7C6B7034

RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-7-jre-headless wget \
    && cd /usr/src \
    && wget http://www-eu.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/apacheds-${APACHEDS_VERSION}.tar.gz \
    && wget http://www-eu.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/apacheds-${APACHEDS_VERSION}.tar.gz.asc \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $APACHEDS_GNUPG_KEY \
    && gpg --verify apacheds-${APACHEDS_VERSION}.tar.gz.asc \
    && echo "${APACHEDS_MD5} apacheds-${APACHEDS_VERSION}.tar.gz" | md5sum -c \
    && useradd -r -d /nonexistant apacheds \
    && mkdir /opt/apacheds \
    && tar xfvz /usr/src/apacheds-${APACHEDS_VERSION}.tar.gz -C /opt/apacheds --strip-components=1 \
    && rm /usr/src/apacheds-${APACHEDS_VERSION}.tar.gz \
    && mv /opt/apacheds/instances/default /opt/apacheds/instances/template \
    && mkdir -p /opt/apacheds/instances/default \
    && chown -R apacheds:apacheds /opt/apacheds/instances \
    && apt-get purge -y --auto-remove wget \
    && rm -r /var/lib/apt/lists/* /root/.gnupg
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/opt/apacheds/instances/default"]
EXPOSE 10389 10636 60088 60088/udp 60464 60464/udp
