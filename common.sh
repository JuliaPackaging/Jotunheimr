#!/bin/bash

# We need a BP-superpowered-Pkg in our Julia
JULIA=${JULIA-julia}
if [[ $($JULIA -e 'import Pkg; try Pkg.Artifacts; println("true"); catch; end') != "true" ]]; then
    echo "ERROR: Must use Pkg/Artifacts-enabled Julia with this repository; build the sf/artifactory branch, then set JULIA to point to that version"
    exit 1
fi

# When building, auto-accept the macOS SDK ToS
export BINARYBUILDER_AUTOMATIC_APPLE=true

# Set things to work in the `.depot` we've already registered things into
export JULIA_DEPOT_PATH=${DIR}/.depot

# Stop if we hit an error
set -e

