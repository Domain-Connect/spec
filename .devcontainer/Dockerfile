FROM docker.io/paulej/rfctools
RUN sudo dnf -y update && sudo dnf -y install git ruby ruby-devel
RUN bash -c "curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/centos.sh | bash" && \
    curl -L https://raw.githubusercontent.com/metanorma/metanorma-linux-setup/master/install-gems.sh | bash
