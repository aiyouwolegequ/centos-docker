FROM 8av36eo/centos7

LABEL version="1.2"

MAINTAINER alaskua.ga

RUN rpm --rebuilddb \
    && rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

RUN yum update -y -q\
    && yum install wget -y -q\
    && yum clean all -q

RUN wget "https://raw.githubusercontent.com/aiyouwolegequ/PentestTools/master/addtools.sh" \
    && sh addtools.sh -i \
    && rm -rf addtools.sh
    
CMD [cd /usr/src/pentest/]