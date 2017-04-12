FROM debian:stretch
MAINTAINER Jacob Chen "jacob2.chen@rock-chips.com"

# setup multiarch enviroment
RUN dpkg --add-architecture armhf
RUN echo "deb-src http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org stretch/updates main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y crossbuild-essential-armhf

# perpare build dependencies
RUN apt-get update && apt-get install -y \
	sudo git fakeroot devscripts cmake vim qemu-user-static binfmt-support dh-make dh-exec \
	pkg-kde-tools device-tree-compiler bc cpio parted dosfstools mtools libssl-dev

RUN apt-get update && apt-get build-dep -y -a armhf libdrm
RUN apt-get update && apt-get build-dep -y -a armhf xorg-server

RUN apt-get update && apt-get install -y libgstreamer-plugins-bad1.0-dev:armhf libgstreamer-plugins-base1.0-dev:armhf libgstreamer1.0-dev:armhf \
libgstreamermm-1.0-dev:armhf libgstreamerd-3-dev:armhf libqt5gstreamer-dev:armhf libqtgstreamer-dev:armhf \
libxfont1-dev:armhf libxxf86dga-dev:armhf libunwind-dev:armhf  libnetcdf-dev:armhf

RUN cp /usr/lib/pkgconfig/xf86dgaproto.pc /usr/lib/arm-linux-gnueabihf/pkgconfig/xf86dgaproto.pc 

## qt-multimedia
RUN apt-get update && apt-get install -y qt5-qmake qt5-qmake:armhf qtbase5-dev:armhf qttools5-dev-tools:armhf qtbase5-dev-tools:armhf libpulse-dev:armhf \
	qtbase5-private-dev:armhf qtbase5-dev:armhf libasound2-dev:armhf libqt5quick5:armhf libqt5multimediaquick-p5:armhf qtdeclarative5-dev:armhf \
	libopenal-dev:armhf qtmultimedia5-examples:armhf

## yocto
RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo  build-essential chrpath socat  xterm locales

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ADD ./overlay/*  /

RUN apt-get update && apt-get install -y -f

# switch to a no-root user
RUN useradd -c 'rk user' -m -d /home/rk -s /bin/bash rk
RUN sed -i -e '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
RUN usermod -a -G sudo rk

USER rk


