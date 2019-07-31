#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/common.sh

# Create a temporary project, install `c_simple_jll`, then try to use it
TEMP_PROJECT=$(mktemp -d)
echo "Installing into temporary Julia project ${TEMP_PROJECT}"

# Load that new `Pkg`, install `c_dependent_jll`
${JULIA} --color=yes --project=${TEMP_PROJECT} -e "import Pkg; Pkg.add(\"c_dependent_jll\")"

# Load `c_dependent_jll` and show that `ccall()` 'just works' right out of the box, as well as `run()`
echo "Testing ccall:"
${JULIA} --color=yes --project=${TEMP_PROJECT} -e "using c_dependent_jll; @show ccall((:my_mult, libdependent), Cint, (Cint, Cint), 2, 3)"
echo "Testing run()'ing deppy in function-call mode:"
${JULIA} --color=yes --project=${TEMP_PROJECT} -e "using c_dependent_jll; deppy(path -> run(\`\$path 2 3\`))"
echo "Testing run()'ing deppy in binary-exec mode:"
${JULIA} --color=yes --project=${TEMP_PROJECT} -e "using c_dependent_jll; deppy(path -> run(\`\$path --exec 2 3\`))"
