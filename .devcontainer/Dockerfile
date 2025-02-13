FROM ghcr.io/ietf-tools/xml2rfc-base:latest

RUN apt-get -y update && apt-get -y install curl && apt-get -y clean

RUN bash -c curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/ubuntu.sh | bash && curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/install-gems.sh | bash

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

RUN apt-get -y update && apt-get -y install git nano default-jre && apt-get -y clean

RUN wget https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar -O /usr/share/java/plantuml.jar

# Specify the working directory when a container is started
WORKDIR /rfc