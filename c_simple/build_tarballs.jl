using BinaryBuilder

name = "c_simple"
version = v"1.2.3"

# Collection of sources required to build libffi
sources = [
    joinpath(@__DIR__, "./bundled"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libc_simple", :libc_simple),
    ExecutableProduct("c_simple", :c_simple),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

