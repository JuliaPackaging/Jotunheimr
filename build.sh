#!/bin/bash

for PROJ in c_simple cxx_string_expansion fortran_expansion; do
    (cd ${PROJ}; julia --color=yes build_tarballs.jl --verbose --debug)
done
