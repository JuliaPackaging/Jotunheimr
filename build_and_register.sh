#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/common.sh

# Now that we have our own depot, use that from here on out; also instantiate things here.
echo "Instantiating Julia environment"
$JULIA --color=yes --project=${DIR} -e "import Pkg; Pkg.instantiate()"

# Create symlink from UUID to "General"
if [[ ! -e ${DIR}/.depot/registries/23338594-aafe-5451-b93e-139f81909106 ]]; then
    ln -sf General ${DIR}/.depot/registries/23338594-aafe-5451-b93e-139f81909106
fi

# Get the current platform as the build target unless if `--all` is supplied
if [[ "$*" != *--all* ]]; then
    target=$($JULIA --project=${DIR} -e 'using Pkg.BinaryPlatforms; print(triplet(platform_key_abi()))')
    echo "Targeting ${target}..."
fi

merge_registrator_branches()
{
    # Merge all "register" branches together in a single sf/pkg_bp_merge branch
    echo "Merging all 'registrator' branches into a single registry branch..."
    ( \
        cd ${DIR}/.depot/registries/General; \
        git checkout -qf master; \
        for b in $(git for-each-ref --format '%(refname:short)' refs/heads/ | grep registrator); do \
            git merge --no-edit -q ${b}; \
        done; \
    )
}

# Build everything
for PROJ in c_simple cxx_string_expansion fortran_expansion; do
( \
    echo "Building ${PROJ}..." && \
    cd ${DIR}/${PROJ} && \
    rm -rf products build && \
    $JULIA --color=yes --project="${DIR}" build_tarballs.jl --verbose --debug --deploy --register="${DIR}/.depot" ${target} ; \
)
done

merge_registrator_branches

# Once we've merged those together, run our dependent build(s)
for PROJ in c_dependent; do
( \
    echo "Building ${PROJ}..." && \
    cd ${DIR}/${PROJ} && \
    rm -rf products build && \
    $JULIA --color=yes --project="${DIR}" build_tarballs.jl --verbose --debug --deploy --register="${DIR}/.depot" ${target} ; \
)
done

merge_registrator_branches
echo "Building, registration and deployment finished, run demos!"
