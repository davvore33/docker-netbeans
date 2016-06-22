FROM ubuntu:14.04
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

COPY brlcad_7.24.0-0_amd64.deb /tmp/brlcad.deb

RUN apt-get update && \
    apt-get install -y fontconfig-config libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libelf1 libfontconfig1 \
    libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libglu1-mesa libice6 libllvm3.4 libpciaccess0 libsm6 libtxc-dxtn-s2tc0 \
    libutempter0 libx11-xcb1 libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-shape0 libxcb-sync1 libxcomposite1 \
    libxdamage1 libxft2 libxinerama1 libxmu6 libxpm4 libxrandr2 libxshmfence1 libxt6 libxv1 libxxf86dga1 libxxf86vm1 x11-utils xbitmaps xterm && \ 
    dpkg -i /tmp/brlcad.deb

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y freecad brlcad oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ADD state.xml /tmp/state.xml

RUN wget http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-javaee-linux.sh -O /tmp/netbeans.sh -q && \
    chmod +x /tmp/netbeans.sh && \
    echo 'Installing netbeans' && \
    /tmp/netbeans.sh --silent --state /tmp/state.xml && \
    rm -rf /tmp/*

ADD run /usr/local/bin/netbeans

RUN chmod +x /usr/local/bin/netbeans && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer

ADD netbeans.conf /usr/local/netbeans-8.1/etc/netbeans.conf

RUN apt-get update && apt-get install -y ure imagemagick

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/netbeans

