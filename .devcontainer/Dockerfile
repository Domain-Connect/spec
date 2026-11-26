# Official metanorma image: ships Ruby, metanorma-cli, xml2rfc, Java and git
# preinstalled, so no gem build is needed here.
FROM metanorma/metanorma:latest

ENV DEBIAN_FRONTEND=noninteractive

# .bashrc configuration
RUN echo 'xml2rfc --version' >> ~/.bashrc && \
    echo 'if [ -d ~/xml2rfc ]; then cd ~/xml2rfc; fi' >> ~/.bashrc

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Extra tools, plus the Pango libraries WeasyPrint needs for xml2rfc --pdf
RUN apt-get -y update && \
    apt-get -y install nano wget fontconfig libpango-1.0-0 libpangoft2-1.0-0 && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*

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

# xml2rfc is preinstalled; add the PDF extras (WeasyPrint)
RUN pip3 install "xml2rfc[pdf]" --break-system-packages

# Specify the working directory when a container is started
WORKDIR /rfc
