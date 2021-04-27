# Building OpenTelemetry C++ SDK with Visual Studio 2019 and CMake

## Prerequisites

The following tools are necessary to build OpenTelemetry C++ SDK from source:

- [Visual Studio 2019 for Windows](https://visualstudio.microsoft.com/downloads/) - Community (FREE), Professional or Enterprise.
- [Windows 10 SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk/)
- [Chocolatey package manager](https://chocolatey.org/)
- [CMake](https://cmake.org/download/)

Please download and install the latest versions of the tools above using their default installation settings.

## Step 1: Installing and Building OpenTelemetry C++ SDK dependencies

[This script](https://github.com/open-telemetry/opentelemetry-cpp/blob/main/tools/setup-buildtools.cmd)
allows to setup the necessary tools, download and build all OpenTelemetry C++ SDK dependencies.

Once you clone the repository, in elevated shell ( Run as Administrator... ), run:

```console
tools\setup-buildtools.cmd
```

## Step 2: Using Visual Studio 2019 for CMake build

Start Visual Studio 2019 and use `[ Open a local folder]` option to open OpenTelemetry C++ SDK folder.




