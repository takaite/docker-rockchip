FROM ubuntu:18.04

run apt-get update

#RUN update-locale en_US.UTF-8
#ENV LANG en_US.UTF-8
#ENV LANGUAGE en_US:en
#ENV LC_ALL en_US.UTF-8

RUN apt-get update -y
RUN apt-get install dialog apt-utils -y

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y -q git u-boot-tools device-tree-compiler mtools parted libudev-dev libusb-1.0-0-dev lib32gcc-6-dev gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu libstdc++-6-dev autoconf autotools-dev libsigsegv2 m4 intltool libdrm-dev curl sed make binutils build-essential gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync file bc wget libncurses5 libglib2.0-dev libgtk2.0-dev libglade2-dev cvs mercurial rsync openssh-client subversion asciidoc w3m dblatex graphviz libssl-dev pv e2fsprogs fakeroot devscripts libi2c-dev libncurses5-dev texinfo liblz4-tool genext2fs

RUN apt-get install -y -q time expect libgpg-error-dev libgcrypt20-dev patchelf

RUN apt-get install -y sudo

RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# switch to a no-root user
RUN useradd -c 'rk user' -m -d /home/rk -s /bin/bash rk | chpasswd && adduser rk sudo
RUN sed -i -e '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
#RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers
RUN usermod -a -G sudo rk
#RUN sudo   ALL=(ALL:ALL) ALL

RUN apt-get install -y lzop gawk

USER rk

