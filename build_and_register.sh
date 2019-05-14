#!/bin/bash

# When building, auto-accept the macOS SDK ToS
export BINARYBUILDER_AUTOMATIC_APPLE=true

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Stop if we hit an error
set -e

# We're going to install everything into a testing depot, and we'll symlink the
# "General" registry to point instead to our locally-modified version:
echo "Initializing hot-patchable registry in ${DIR}/.depot/registries..."
mkdir -p ${DIR}/.depot/registries
if [[ ! -h ${DIR}/.depot/registries/General ]]; then
    ln -sf 23338594-aafe-5451-b93e-139f81909106 ${DIR}/.depot/registries/General
fi

# We need the `master` branch of our registry to contain a machine-editable version
# of Registry.toml, so we manually set that up by round-tripping it through TOML:
julia --project=${DIR} -e "using Registrator; Registrator.get_registry(Registrator.DEFAULT_REGISTRY; registries_root=\"${DIR}/.depot\", force_reset=false)"
(
    cd ${DIR}/.depot/registries/General && \
    julia --project=${DIR} -e "using Registrator; f=\"Registry.toml\"; Registrator.write_toml(f, Registrator.TOML.parsefile(f))" && \
    git commit -a -m "Make Registry.toml machine-mergable"
)

# Get the current platform as the build target unless if `--all` is supplied
if [[ "$*" != *--all* ]]; then
    target=$(julia --project=${DIR} -e 'using Pkg; print(triplet(platform_key_abi()))')
    echo "Targeting ${target}..."
fi

# We're going to upload to our own forks, so as not to clobber the main Jotunheimr
# repo with different people's binaries
if [[ -z ${GITHUB_USERNAME} ]]; then
    echo "Must define GITHUB_USERNAME"
    exit 1
else
    # This overrides the typical choice, which would be to analyze the git origin.
    # But we don't want to upload to `JuliaPackaging/Jotunheimr`, so we avoid that.
    export CI_REPO_OWNER=${GITHUB_USERNAME}
    export CI_REPO_NAME=Jotunheimr
    echo "We will upload to github.com/${CI_REPO_OWNER}/${CI_REPO_NAME}"
fi

# Build everything
for PROJ in c_simple cxx_string_expansion fortran_expansion; do
    ( \
        echo "Building ${PROJ}..." && \
        cd ${DIR}/${PROJ} && \
        julia --project="${DIR}" --color=yes build_tarballs.jl --verbose --debug --deploy --register="${DIR}/.depot" ${target} ; \
    )
done

# Merge all "register" branches together in a single sf/pkg_bp_merge branch
echo "Merging all 'register' branches into a single registry branch..."
( \
    cd ${DIR}/.depot/registries/General; \
    git checkout -qf master; \
    git branch -qf sf/pkg_bp_merge; \
    git checkout -qf sf/pkg_bp_merge; \
    for b in $(git for-each-ref --format '%(refname:short)' refs/heads/ | grep register); do \
        git merge --no-edit -q ${b}; \
    done; \
)

echo "Building, registration and deployment finished, run demos!"
