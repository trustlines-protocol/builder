This directory contains a Dockerfile, which is used to create an ubuntu 18.04
based image to be used as a build executor on CircleCI.

# What's inside

The image comes with some things pre-installed.

## Postgresql 

The PostgreSQL server and dev files are installed.

## Image name
The name:tag of the image will be `trustlines/builder:$CIRCLE_BRANCH$CIRCLE_BUILD_NUM`.
To check the most recent tag, go to the [dockerhub repo](https://hub.docker.com/r/trustlines/builder/tags) of trustlines/builder.


## Solidity
Currently the image contains solidity versions 0.4.25, 0.4.26, 0.5.1, 0.5.7, and 0.5.8.

You can choose the version that's being used by setting the SOLC_VERSION
environment variable.

This could be done in the executor definition, e.g. the following will choose
solidity 0.4.25::

    executors:
      ubuntu-builder:
        docker:
          - image: trustlines/builder:master9
            environment:
              - SOLC_VERSION=v0.4.25
        working_directory: ~/repo

## Nvm

The image has Node Version Manager installed with nodejs 10.14.2 already installed.

Enable it by configuring something like:

    config-path:
      description: "set environment variables and change PATH"
      steps:
      - run:
          name: Configuring PATH
          command: |
            echo >> ${BASH_ENV} 'export PATH=~/bin:~/repo/venv/bin:${PATH}'
            echo >> ${BASH_ENV} '. ~/.nvm/nvm.sh'
  
## Twine
twine can be used to upload python packages to pypi.

## shellcheck
shellcheck is a linter for shell scripts.

## shfmt
shfmt is a shell script autoformatter.

# Changing the image

Please feel free to change the image according to your needs, but try to stay
backwards compatible. E.g. if you add a new solidity version, don't remove the
old version unless you're sure it's not being used anymore. This will allow us
to use the latest image everywhere.
