# Dockerfile to include and start an MC in a docker container 
# on a ubuntu 16.04 LTS build with current JDK
FROM ubuntu:xenial
LABEL tag="turchinc/mediacockpit-base" vendor="Bertsch Innovation GmbH"
MAINTAINER Chris Turchin <chris.turchin@bertschinnovation.com>
ENV DEBIAN_FRONTEND noninteractive

#install jdk as per example from isuper/oracle but newer version and on 16.04
ENV VERSION 8
ENV UPDATE 92
ENV BUILD 14
ENV JAVA_HOME /usr/lib/jvm/java-${VERSION}-oracle
ENV JRE_HOME ${JAVA_HOME}/jre

RUN apt-get update && apt-get install openssl libssl-dev wget \
        -y --no-install-recommends && \
	wget -O - --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"u"${UPDATE}"-b"${BUILD}"/server-jre-"${VERSION}"u"${UPDATE}"-linux-x64.tar.gz \
	| tar xz -C /tmp && \
	mkdir -p /usr/lib/jvm && mv /tmp/jdk1.${VERSION}.0_${UPDATE} "${JAVA_HOME}" && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/bin/java" 1 && \
	update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
	update-alternatives --set java "${JRE_HOME}/bin/java" && \
	update-alternatives --set javac "${JAVA_HOME}/bin/javac"
