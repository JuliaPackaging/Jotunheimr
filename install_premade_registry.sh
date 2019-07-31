#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Just clone the right version of our registry fork
mkdir -p ${DIR}/.depot/registries
( \
    cd ${DIR}/.depot/registries && \
    git clone -b master https://github.com/staticfloat/General \
)
