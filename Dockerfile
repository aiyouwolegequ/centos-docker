FROM centos:7.4.1708

LABEL Docker Version="1.0" \
      Tools Version="1.0" \
      Maintainer="alaskua.ga"

RUN rpm --rebuilddb \
    && rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org \
    && yum clean all -y \
    && rm -rf /var/cache/yum \
    && yum install wget git -y -q

RUN wget "https://raw.githubusercontent.com/aiyouwolegequ/centos-docker/master/install_zsh.sh" \
    && sh install_zsh.sh \
    && rm -rf install_zsh.sh

RUN wget "https://raw.githubusercontent.com/aiyouwolegequ/centos-docker/master/install_tools.sh" \
    && sh addtools.sh -i \
    && rm -rf addtools.sh

WORKDIR /usr/src/pentest/

CMD ["/bin/zsh"]