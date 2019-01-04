This directory contains a Dockerfile, which is used to create an ubuntu 18.04
based image to be used as a build executor on CircleCI.

# What's inside

The image comes with some things preinstalled.

## Postgresql 

The PostgreSQL server and dev files are installed.

## Solidity
Currently the image contains solidity 0.4.24 and 0.5.1.

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
