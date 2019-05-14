#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Initializing submodules..."
git submodule init
git submodule update

echo "Instantiating Julia environment"
julia --project=${DIR} -e "import Pkg; Pkg.instantiate()"
