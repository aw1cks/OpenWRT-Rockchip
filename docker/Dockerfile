FROM ubuntu:18.04
RUN apt-get update -y && \
    DEBIAN_FRONTEND="noninteractive" TZ="Europe/London" apt-get install -y build-essential rsync asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core p7zip p7zip-full msmtp libssl-dev texinfo libreadline-dev libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint ccache curl wget vim nano python3 python3-pip python3-ply haveged lrzsz device-tree-compiler scons tzdata sudo pigz && \
    wget -qO - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | sed 's/python-/python3-/g' | /bin/bash && \
    apt-get clean -y && \
    groupadd -g 1000 build && \
    useradd -m -g 1000 -d /build build
USER build
