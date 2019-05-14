# Jotunheimr

A testing repository for the next iteration of BinaryBuilder and Pkg; a smaller, colder [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil).


# Setup

First, ensure you've got all the code (including the `Pkg.jl` submodule).  Run the setup script that ensures that you've got all submodules and have instantiated the master environment:

```bash
$ ./setup.sh
```

# Building

You can build your very own versions of the three testing packages (`c_simple`, `cxx_string_expansion` and `fortran_expansion`)!  What fun!  If you don't want to do this, just run `./intall_premade_registry.sh` and skip this section.

Let's build ourselves some binary packages.  You could do it manually, but why do that when we can run scripts full of arcane commands?  Note that you will need a few things exported to your environment and [`ghr`](https://github.com/tcnksm/ghr/releases/tag/v0.12.1) on your `PATH` for this to work (In the future we will, of course, provide `ghr` through the very mechanism being tested here).  This is because it will be uploading binary artifacts to your fork of `Jotunheimr`'s github releases. An example invocation looks something like:

```bash
$ export GITHUB_TOKEN=1a2b3c...
$ export GITHUB_USERNAME=staticfloat
$ ./build_and_register.sh [--quick]
```

Make sure that you've [forked Jotunheimr first](https://github.com/JuliaPackaging/Jotunheimr/fork), of course, for there to be a repository where it can upload the artifacts to.  This will build binary artifacts for all platforms (or only your currently-running platform if `--quick` is set; this will cut down on waiting time SIGNIFICANTLY and is highly recommended)
