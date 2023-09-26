FROM ubuntu/ubuntu:focal

ENV TZ=Australia/Sydney
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
RUN ln -s /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y \
    wget \
    openjdk-8-jre \
    ca-certificates

ENV LANG=C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN apt-get update

RUN apt-get install --yes nginx supervisor postgresql \
  && rm  -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/nginx

WORKDIR /pulsar-manager

COPY pulsar-manager-0.4.0.tar.gz .

RUN tar -zxf pulsar-manager-0.4.0.tar.gz .

RUN rm -r pulsar-manager-0.4.0.tar.gz

RUN cp docker/supervisord.conf /etc/

RUN cp docker/supervisord-token.conf /etc/

RUN cp docker/supervisord-private-key.conf /etc/

RUN cp docker/supervisord-secret-key.conf /etc/

RUN cp docker/supervisord-configuration-file.conf /etc/

RUN cp docker/default.conf /etc/nginx/conf.d/

RUN cp docker/startup.sh /pulsar-manager/

RUN cp docker/init_db.sql /pulsar-manager/

RUN cp docker/entrypoint.sh /pulsar-manager/

RUN cp -r front-end/dist/ /usr/share/nginx/html/

ENTRYPOINT [ "/pulsar-manager/entrypoint.sh" ]
