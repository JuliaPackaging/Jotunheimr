# Jotunheimr

A testing repository for the next iteration of BinaryBuilder and Pkg; a smaller, colder [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil).


# Setup

First, ensure you've got all the code (including the `Pkg.jl` submodule).  Run the setup script that ensures that you've got all submodules and have instantiated the master environment:

```bash
# Setup submodules and environments
$ ./setup.sh
```

# Building

You can build your very own versions of the three testing packages (`c_simple`, `cxx_string_expansion` and `fortran_expansion`)!  What fun!  If you don't want to do this, just run the following line and then skip this section, heading off to `Testing`:
```
# For those that don't want to rebuild the examples with BinaryBuilder
$ ./install_premade_registry.sh
```

Let's build ourselves some binary packages.  You could do it manually, but why do that when we can run scripts full of arcane commands?  Note that you will need a few things exported to your environment and [`ghr`](https://github.com/tcnksm/ghr/releases/tag/v0.12.1) on your `PATH` for this to work (In the future we will, of course, provide `ghr` through the very mechanism being tested here).  This is because it will be uploading binary artifacts to your fork of `Jotunheimr`'s github releases. An example invocation looks something like:

```bash
# Build all the things!
$ export GITHUB_TOKEN=1a2b3c...
$ export GITHUB_USERNAME=staticfloat
$ ./build_and_register.sh [--all]
```

Make sure that you've [forked Jotunheimr first](https://github.com/JuliaPackaging/Jotunheimr/fork), of course, for there to be a repository where it can upload the artifacts to.  This will build, deploy and register the binary artifacts for the current platforms (or all platforms if `--all` is set; this will trigger downloading of all compiler shards, and should only be done by the most adventurous of binary builders).  Note that for real-world usage, the analog of `--all` mode will always be used; by forcing to only build an exact match for the current platform we get some slightly weird results, but it's good enough for a demo.

# Testing

We have only a single demonstration enabled at the moment: `demo_c_simple.sh`.  After either insntalling a premade registry, or building, deploying and registering a new set of binaries, run `./demo_c_simple.sh` to install the `c_simple` binaries into a temporary directory and run a `ccall()` against `libc_simple`.

Expected output is something akin to the following:
```
$ ./demo_c_simple.sh
<installs into random temporary project>
ccall((:my_add, libc_simple), Cint, (Cint, Cint), 2, 3) = 5
```
