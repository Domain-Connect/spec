# Official metanorma image: ships Ruby, metanorma-cli, xml2rfc, Java and git
# preinstalled, so no gem build is needed here.
FROM metanorma/metanorma:latest

ENV DEBIAN_FRONTEND=noninteractive

# .bashrc configuration
RUN echo 'xml2rfc --version' >> ~/.bashrc && \
    echo 'if [ -d ~/xml2rfc ]; then cd ~/xml2rfc; fi' >> ~/.bashrc

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Extra tools (SSH client for git over SSH, GitHub CLI), plus the Pango
# libraries WeasyPrint needs for xml2rfc --pdf
RUN apt-get -y update && \
    apt-get -y install nano wget less openssh-client ca-certificates fontconfig \
        libpango-1.0-0 libpangoft2-1.0-0 && \
    mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/githubcli-archive-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list && \
    apt-get -y update && apt-get -y install gh && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*

# The bind-mounted workspace is owned by the host user, not root; let git use it
RUN git config --system --add safe.directory '*'

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
