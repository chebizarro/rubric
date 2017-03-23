FROM ubuntu:latest
MAINTAINER Chris Daley <chebizarro@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# ===== create user/setup environment =====
# Replace 1000 with your user/group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
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

RUN apt-get update && apt-get install -y --fix-missing \
	git \
	autoconf \
	libtool \
	libtool-bin \
	automake \
	build-essential \
	gettext \
	make \
	shtool \
	lcov \
	gtk-doc-tools \
	valac \
	libgirepository1.0-dev \
	libxml2-dev \
	gtk-doc-tools \
	libjson-glib-dev \
	libxslt1-dev \
	valadoc \
	libgee-0.8-dev \
	valadate \
	libfcgi-dev \
    libglib2.0-dev \
    libsoup2.4-dev \
    python3-pip \
	unzip
	
RUN pip3 install gcovr meson

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Ninja
ADD https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-linux.zip /tmp
RUN unzip /tmp/ninja-linux.zip -d /usr/local/bin

RUN git clone https://github.com/valum-framework/valum.git /tmp/valum

WORKDIR /tmp/valum
RUN mkdir build && meson --prefix=/usr --buildtype=release . build && ninja -C build && ninja -C build test && ninja -C build install

RUN apt-get install -y --fix-missing \
	libpeas-dev \
	libgom-1.0-dev

RUN mkdir /etc/sudoers.d/

RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

RUN apt-get install -y --fix-missing \
	libsqlite3-dev \
	libxml2-utils \
	sudo

ENV HOME /home/developer
ENV USER developer
USER developer
RUN mkdir -p /home/developer/build/rubric
WORKDIR /home/developer/build/rubric

CMD ["bash"]
