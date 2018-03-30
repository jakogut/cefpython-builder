FROM ubuntu:14.04
MAINTAINER jakogut <joseph.kogut@gmail.com>
WORKDIR /src
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y bison build-essential cdbs curl devscripts dpkg-dev elfutils fakeroot flex g++ git-core git-svn gperf libapache2-mod-php5 libasound2-dev libav-tools libbrlapi-dev libbz2-dev libcairo2-dev libcap-dev libcups2-dev libcurl4-gnutls-dev libdrm-dev libelf-dev libexif-dev libffi-dev libgconf2-dev libgl1-mesa-dev libglib2.0-dev libglu1-mesa-dev libgnome-keyring-dev libgtk2.0-dev libjpeg-dev libkrb5-dev libnspr4-dev libnss3-dev libpam0g-dev libpci-dev libpulse-dev libsctp-dev libspeechd-dev libsqlite3-dev libssl-dev libudev-dev libwww-perl libxslt1-dev libxss-dev libxt-dev libxtst-dev mesa-common-dev openbox patch perl php5-cgi pkg-config python python-cherrypy3 python-crypto python-dev python-psutil python-numpy python-opencv python-openssl python-yaml rpm ruby subversion ttf-dejavu-core ttf-indic-fonts ttf-kochi-gothic ttf-kochi-mincho fonts-thai-tlwg wdiff wget zip equivs libgtkglext1-dev cmake python-pip bsdtar

RUN wget -qO- https://github.com/ninja-build/ninja/releases/download/v1.7.2/ninja-linux.zip | \
	bsdtar -xvf- -C /usr/bin && chmod 0755 /usr/bin/ninja

ADD cefpython/tools/requirements.txt .
RUN pip install --upgrade -r requirements.txt
