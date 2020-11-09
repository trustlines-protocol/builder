#
# you can build the image with:
#
#   docker build . -t builder

FROM circleci/buildpack-deps:bionic
WORKDIR /home/circleci
RUN sudo apt-get update && \
    sudo apt-get install -y build-essential apt-utils libssl-dev curl graphviz \
         libsecp256k1-dev python3 python3-distutils python3-dev python3-venv \
         python3-virtualenv virtualenv git build-essential postgresql-10 libpq-dev \
         libgraphviz-dev libsecp256k1-dev pkg-config pipsi ruby-dev shellcheck && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo gem install fpm
RUN mkdir bin
RUN pipsi install twine

# Install nvm with node and npm
ENV NODE_VERSION 10.14.2
ENV NVM_DIR /home/circleci/.nvm
RUN mkdir -p $NVM_DIR; curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

RUN curl -L -o ~/bin/shfmt https://github.com/mvdan/sh/releases/download/v2.6.4/shfmt_v2.6.4_linux_amd64 && chmod +x ~/bin/shfmt

# -- Install solidity
RUN curl -L -o ~/bin/solc-v0.4.25 https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux && chmod +x ~/bin/solc-v0.4.25
RUN curl -L -o ~/bin/solc-v0.4.26 https://github.com/ethereum/solidity/releases/download/v0.4.26/solc-static-linux && chmod +x ~/bin/solc-v0.4.26
RUN curl -L -o ~/bin/solc-v0.5.1 https://github.com/ethereum/solidity/releases/download/v0.5.1/solc-static-linux && chmod +x ~/bin/solc-v0.5.1
RUN curl -L -o ~/bin/solc-v0.5.7 https://github.com/ethereum/solidity/releases/download/v0.5.7/solc-static-linux && chmod +x ~/bin/solc-v0.5.7
RUN curl -L -o ~/bin/solc-v0.5.8 https://github.com/ethereum/solidity/releases/download/v0.5.8/solc-static-linux && chmod +x ~/bin/solc-v0.5.8

# Donload unzip
RUN sudo apt-get install -y unzip

# Download openethereum 3.1.0
RUN curl -L -o openethereum_zip https://github.com/openethereum/openethereum/releases/download/v3.1.0/openethereum-linux-v3.1.0.zip
RUN sudo echo b5a924c625de2f18981ec5514782c6eb4c14db82a8788f7084667a9d8bcb74f6 openethereum_zip | sha256sum -c \
&& unzip -j openethereum_zip openethereum -d ~/bin/ \
&& chmod 755 ~/bin/openethereum \
&& rm -f openethereum_zip

RUN echo 'export PATH=~/venv/bin:~/bin:~/.local/bin:$PATH' >>.bashrc
COPY solc ./bin/
CMD ["/bin/bash"]
