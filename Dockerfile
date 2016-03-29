FROM debian:wheezy 
MAINTAINER Paolo Di Tommaso

ENV DEBIAN_FRONTEND noninteractive

RUN \
    echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90forceyes;\
    echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list;\
    echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates  main universe restricted' >> /etc/apt/sources.list;\
    apt-get update;\
    echo exit 101 > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d;\
    dpkg-divert --local --rename --add /sbin/initctl;\
    ln -sf /bin/true /sbin/initctl;\
    apt-get -y upgrade && apt-get clean ;\
    apt-get install --force-yes gcc-multilib wget

RUN \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O jdk-1_5_0_22-linux-amd64.bin http://download.oracle.com/otn-pub/java/jdk/1.5.0_22/jdk-1_5_0_22-linux-amd64.bin

# alternate  java method disabled: download local jdk
#ADD jdk-1_5_0_22-linux-amd64.bin /tmp/

RUN \
    echo yes|sh ./jdk-1_5_0_22-linux-amd64.bin ;\
    rm jdk-1_5_0_22-linux-amd64.bin

ENV JAVA_HOME /jdk1.5.0_22
ENV PATH /jdk1.5.0_22/bin:$PATH

RUN wget -O- -q http://archive.apache.org/dist/ant/binaries/apache-ant-1.6.5-bin.tar.gz | tar xz

ENV ANT_HOME=/apache-ant-1.6.5
ENV PATH=$ANT_HOME/bin:$PATH

RUN wget -O- -q http://tenet.dl.sourceforge.net/project/sslexplorer/SSL-Explorer%201.0/1.0.0_RC17/sslexplorer-1.0.0_RC17-src.tar.gz | tar xz

WORKDIR /sslexplorer-1.0.0_RC17
EXPOSE 28080
CMD ["ant","install"]

