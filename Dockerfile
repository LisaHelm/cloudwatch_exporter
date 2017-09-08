FROM openjdk
MAINTAINER Prometheus Team <prometheus-developers@googlegroups.com>
EXPOSE 9106

WORKDIR /cloudwatch_exporter
ADD . /cloudwatch_exporter
RUN apt-get -qy update && apt-get -qy install maven && mvn package && \
    mv target/cloudwatch_exporter-*-with-dependencies.jar /cloudwatch_exporter.jar && \
    rm -rf /cloudwatch_exporter && apt-get -qy remove --purge maven && apt-get -qy autoremove
WORKDIR /

RUN mkdir /config
ONBUILD ADD config.yml /config/
ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106", "/config/config.yml" ]
