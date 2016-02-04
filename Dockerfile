FROM rawmind/rancher-base:0.0.2-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

#Set environment
ENV VAMP_VERSION=0.8.2 \
    VAMP_HOME=/opt/vamp \
ENV VAMP_RELEASE=vamp-gateway-agent_${VAMP_VERSION}_linux_amd64.zip

# Install haproxy
RUN apk --update add musl-dev linux-headers curl gcc pcre-dev make zlib-dev && \
    mkdir /usr/src && \
    curl -fL http://www.haproxy.org/download/1.6/src/haproxy-1.6.3.tar.gz | tar xzf - -C /usr/src && \
    cd /usr/src/haproxy-1.6.3 && \
    make TARGET=linux2628 USE_PCRE=1 USE_ZLIB=1 && \
    make install-bin && \
    cd .. && \
    rm -rf /usr/src/haproxy-1.6.3 && \
    apk del musl-dev linux-headers curl gcc pcre-dev make zlib-dev && \
    apk add musl pcre zlib && \
    rm /var/cache/apk/*

# Install vamp-gateway-agent
RUN mkdir -p ${VAMP_HOME}/log && cd ${VAMP_HOME} && \
    wget https://bintray.com/artifact/download/magnetic-io/downloads/vamp-gateway-agent/${VAMP_RELEASE} && \
    unzip ${VAMP_RELEASE} && rm ${VAMP_RELEASE} && \
    chmod 755 vamp-gateway-agent

# Add start.sh 
ADD start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/*.sh 

WORKDIR /opt/vamp

ENTRYPOINT /usr/bin/start.sh
