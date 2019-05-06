using BinaryBuilder

name = "cxx_string"
version = v"1.2.3"

# Collection of sources required to build libffi
sources = [
    "./bundled",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxx_versions(supported_platforms())

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcxx_string", :libcxx_string)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

