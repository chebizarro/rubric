FROM ubuntu:latest
MAINTAINER Chris Daley <chebizarro@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# ===== create user/setup environment =====
# Replace 1000 with your user/group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d/ && \
    echo "developer:x:${uid}:${gid}:developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
	echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN apt-get update && apt-get dist-upgrade -y

# Install the basic build tools needed for most projects
RUN apt-get install -y --fix-missing \
	software-properties-common \
	curl

RUN curl https://www.valadate.org/jenkins@valadate.org.gpg.key | apt-key add -
RUN echo "deb	http://www.valadate.org/repos/debian valadate main" >> /etc/apt/sources.list

# Get the latest version of vala	
RUN add-apt-repository ppa:vala-team

# Get the v8 5.2 build
RUN add-apt-repository ppa:pinepain/libv8-5.2

RUN apt-get update && apt-get install -y --fix-missing \
	git \
    python3-pip \
	unzip \
	autoconf \
	libtool \
	libtool-bin \
	automake \
	build-essential \
	gettext \
	make \
	shtool \
	lcov \
	libxml2-dev \
	libxslt1-dev \
	libxml2-utils \
	gtk-doc-tools \
	libcanberra-gtk-module \
	dbus \
	libdbus-1-dev \
	dbus-x11 \
	valac \
	valadoc \
	valadate \
	libgirepository1.0-dev \
	libjson-glib-dev \
	libgee-0.8-dev \
	libsqlite3-dev \
	libpeas-dev \
	libgom-1.0-dev \
	libfcgi-dev \
    libglib2.0-dev \
    libsoup2.4-dev \
    libmozjs-24-dev
	
RUN pip3 install gcovr meson

# Ninja
ADD https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-linux.zip /tmp
RUN unzip /tmp/ninja-linux.zip -d /usr/local/bin

RUN git clone https://github.com/valum-framework/valum.git /tmp/valum
WORKDIR /tmp/valum
RUN mkdir build && meson --prefix=/usr --buildtype=release . build && ninja -C build && ninja -C build test && ninja -C build install

RUN apt-get install -y --fix-missing \
	sudo

ENV HOME /home/developer
ENV USER developer
USER developer
RUN mkdir -p /home/developer/build/rubric
WORKDIR /home/developer/build/rubric

CMD ["bash"]
