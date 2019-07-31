# Jotunheimr

A testing repository for the next iteration of BinaryBuilder and Pkg; a smaller, colder [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil).

# Build Julia

You're going to need a Julia that knows about Artifacts.  Go ahead and clone Julia, building the [`sf/artifactory` branch](https://github.com/JuliaLang/julia/tree/sf/pkg_artifactory).  When running the examples below, if that `julia` is not the default one on your path, the scripts will complain that your `julia` version is not `Artifact`-capable.  You can tell it which exact `julia` executable to use during operations by exporting `JULIA=/path/to/julia`.

# Building

You can build your very own versions of the four testing packages (`c_simple`, `cxx_string_expansion`, `fortran_expansion` and `c_dependent`)!  What fun!  If you don't want to do this, just run the following line and then skip this section, heading off to `Testing`:
```
# For those that don't want to rebuild the examples with BinaryBuilder
$ ./install_premade_registry.sh
```

Let's build ourselves some binary packages.  You could do it manually, but why do that when we can run scripts full of arcane commands?  Note that you will need a few things exported to your environment and [`ghr`](https://github.com/tcnksm/ghr/releases/tag/v0.12.1) on your `PATH` for this to work (In the future we will, of course, provide `ghr` through the very mechanism being tested here).  This is because it will be uploading binary artifacts to your fork of `Jotunheimr`'s github releases. An example invocation looks something like:

```bash
# Build all the things!
$ export GITHUB_TOKEN=1a2b3c...
$ export JULIA=/path/to/julia
$ ./build_and_register.sh [--all]
```

By default it's going to attempt to upload packages to the `JuliaBinaryWrappers` organization.  Most likely you will not have access to this, so if you really want to do this, message `@staticfloat` and ask him for access to that organization. This will build, deploy and register the binary artifacts for the current platforms (or all platforms if `--all` is set; this will trigger downloading of all compiler shards, and should only be done by the most adventurous of binary builders).  Note that for real-world usage, the analog of `--all` mode will always be used; by forcing to only build an exact match for the current platform we get some slightly weird results, but it's good enough for a demo.

# Testing

We have two fully automated tests; `c_simple` and `c_dependent`. After either installing a premade registry, or building, deploying and registering a new set of binaries, run `./demo_c_simple.sh` to install the `c_simple` binaries into a temporary directory and run a `ccall()` against `libc_simple`.

## `c_simple` testing

Expected output is something akin to the following:
```
$ ./demo_c_simple.sh
<installs into random temporary project>
ccall((:my_add, libc_simple), Cint, (Cint, Cint), 2, 3) = 5
```

Note that `c_simple_jll` also includes a binary (called `c_simple`) that can be invoked via `run()` to call the library function for you, simulating a bundled CLI tool.  Here's a manual example of how you might do that:
```
$ JULIA_DEPOT_PATH=$(pwd)/.depot ${JULIA} --project=/tmp/c_simple_test
(c_simple_test) pkg> add c_simple_jll
...
julia> using c_simple_jll
julia> c_simple() do exe_path
           run(`$exe_path 2 3`)
       end
2 + 3 == 5
```

## `c_dependent` testing

The second test is slightly more involved.  `c_dependent` implements a `my_mult` function that calls the `my_add` function within `c_simple` repeatedly in order to effect multiplication.  It also has a binary that can be invoked to both call `my_add` within `libc_simple` or to `exec` `c_simple` repeatedly.  Running the test suite tests all three of these code paths, and should look something like this:

```
$ ./demo_c_dependent.sh
<installs into random temporary project>
Testing ccall:
ccall((:my_mult, libdependent), Cint, (Cint, Cint), 2, 3) = 6
Testing run()'ing deppy in function-call mode:
2 * 3 == 6
Testing run()'ing deppy in binary-exec mode:
2 * 3 == 6
```

In order for this demo to work, the following things must be happening properly:

* `c_dependent_jll` must correctly express a dependency on `c_simple_jll` within the registry, and install it automatically.
* `libdependent` and `deppy` must both have dynamic links that are correctly resolved to `libc_simple` at load-time, automatically.
* `deppy` must have its `PATH` and `LD_LIBRARY_PATH` correctly set before it is executed so that when it is invoked via `run()`, it can find those other executables and binaries.
