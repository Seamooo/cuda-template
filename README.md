# Cuda Template

This template uses bazel, clang, and cuda for its build toolchain.

It's possible to use gcc at the expense of `compile_commands.json` breaking

Additionally clang-format, clang-tidy, and clangd are recommended for code quality
and editor integration

This template is tested on linux but potentially works with any sh-based shell,
however, installation instructions are unavailable.

Included in this is thrust due to it's popularity, utility and illustrates
external dependency usage

## Toolchain Installation

### Ubuntu

- `sudo apt install -y gcc clang clang-format clang-tidy clangd`
- [bazel](https://bazel.build/install)
- [cuda toolkit](https://developer.nvidia.com/cuda-downloads)
- Add this to `~/.bashrc`: `export CUDA_PATH=/usr/local/cuda`

## Commands

This template uses make as the basis for running commands:

**TODO**: setup unit tests

- `make run`: builds and runs the executable
- `make build`: builds the executable
- `make env_setup`: builds the `compile_commands.json` compilation database
- `make fmt`: runs clang-format
- `make lint`: runs clang-tidy

## Common Pitfalls

- If stl files are failing to be found ensure that the latest gcc package installed
  has its corresponding `libstdc++-${VERSION_NUMBER}-dev` package installed. It is
  common during cuda installation that an upgraded gcc version is required. Cuda
  does not install the corresponding libstdc++ by default, only gcc.
  - To check run `dpkg -l | grep gcc` and look for the largest version number
    `gcc-${VERSION_NUMBER}`. Then run `dpkg -l | grep libstdc++` to ensure that
    the corresponding stl is installed
- To maintain parity between editor and build, ensure that `make env_setup` is
  run regularly (ie on change to bazel files)
- Linting is slightly broken right now, all header files are expected to
  be hpp as clang-tidy treats `.h` extensions as C files, not accepting c++ cli args
- When including standard library files in cuda code, ensure to wrap the include
  in an undef and redef of `__noinline__`
