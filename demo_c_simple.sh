#!/bin/bash

# Set things to work in the `.depot` we've already registered things into
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export JULIA_DEPOT_PATH=${DIR}/.depot

# Create a temporary project, install `c_simple_jll`, then try to use it
TEMP_PROJECT=$(mktemp -d)
echo "Installing into temporary Julia project ${TEMP_PROJECT}"

# Override `Pkg` within our `Project.toml`
julia --project=${TEMP_PROJECT} -e "import Pkg; Pkg.develop(Pkg.PackageSpec(path=\"${DIR}/Pkg.jl\"))"

# Load that new `Pkg`, install `c_simple_jll`
julia --project=${TEMP_PROJECT} -e "import Pkg; Pkg.add(\"c_simple_jll\")"

# Load `c_simple_jll` and show that `ccall()` 'just works' right out of the box
julia --project=${TEMP_PROJECT} -e "using c_simple_jll; @show ccall((:my_add, libc_simple), Cint, (Cint, Cint), 2, 3)"
