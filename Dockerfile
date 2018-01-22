FROM 8av36eo/centos7

LABEL version="1.1"

MAINTAINER alaskua.ga

RUN rpm --rebuilddb \
    && rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

RUN yum -y install epel-release \
    && yum -y install \
        asciidoc \
        autoconf \
        automake \
        bind-utils \
        bzip2 \
        bzip2-devel \
        c-ares-devel \
        curl \
        finger \
        gawk \
        gcc \
        gcc-c++ \
        gettext \
        git \
        glibc-static \
        iproute \
        libcurl-devel \
        libev-devel \
        libevent-devel \
        libffi-devel \
        libstdc++-static \
        libtool \
        libtool-ltdl-devel \
        lsof \
        m2crypto \
        make \
        mlocate \
        ncurses-devel \
        net-tools \
        openssl-devel \
        patch \
        pcre-devel \
        policycoreutils-python \
        ppp \
        psmisc \
        python-devel \
        python-pip \
        python-setuptools \
        python34 \
        python34-devel \
        readline \
        readline-devel \
        ruby \
        ruby-dev \
        rubygems \
        sqlite-devel \
        swig \
        sysstat \
        tar \
        tk-devel \
        tree \
        unzip \
        vim \
        wget \
        xmlto \
        zlib \
        zlib-devel \
    && yum clean all

RUN wget "https://bootstrap.pypa.io/get-pip.py" && python get-pip.py \
    && python3 get-pip.py \
    && python -m pip install -U pip \
    && python -m pip install -U distribute \
    && python3 -m pip install --upgrade pip \
    && python -m pip install pycurl pygments dnspython gevent wafw00f censys selenium BeautifulSoup4 json2html tabulate configparser parse wfuzz feedparser greenlet \
    && python3 -m pip install scrapy docopt twisted lxml parsel w3lib cryptography pyopenssl anubis-netsec plecost json2html tabulate \
    && easy_install shodan \
    && easy_install supervisor \
    && updatedb \
    && locate inittab \
    && rm -rf get-pip.py

RUN wget "https://raw.githubusercontent.com/aiyouwolegequ/PentestTools/master/addtools.sh" && sh addtools.sh -i \
    && rm -rf addtools.sh
    
CMD [cd /usr/src/pentest/]