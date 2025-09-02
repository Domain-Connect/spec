FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

# .bashrc configuration
RUN echo 'xml2rfc --version' >> ~/.bashrc && \
    echo 'if [ -d ~/xml2rfc ]; then cd ~/xml2rfc; fi' >> ~/.bashrc

RUN apt-get -y update && apt-get -y install curl gpg build-essential && apt-get -y clean

RUN bash -c curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/ubuntu.sh | bash && curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/install-gems.sh | bash

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Install Java JRE needed for plantuml
RUN apt-get -y update && apt-get -y install git nano default-jre wget && apt-get -y clean

# Install Plantuml
RUN wget https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar -O /usr/share/java/plantuml.jar

# Install required fonts
RUN mkdir -p ~/.fonts/opentype /tmp/fonts && \
    wget --progress=bar:force -O /tmp/fonts.tar.gz https://github.com/ietf-tools/xml2rfc-fonts/archive/refs/tags/3.22.0.tar.gz && \
    tar zxf /tmp/fonts.tar.gz -C /tmp/fonts && \
    mv /tmp/fonts/*/noto/* ~/.fonts/opentype/ && \
    mv /tmp/fonts/*/roboto_mono/* ~/.fonts/opentype/ && \
    rm -rf /tmp/fonts.tar.gz /tmp/fonts/ && \
    fc-cache -f

# Install xml2rfc and dependencies
RUN apt-get -y install python3-pip python3-setuptools python3-wheel && \
    pip3 install xml2rfc --ignore-installed six chardet "xml2rfc[pdf]" --break-system-packages

# Specify the working directory when a container is started
WORKDIR /rfc