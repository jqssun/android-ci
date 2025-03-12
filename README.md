# Android CI

[![license](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/jqssun/android-ci/blob/master/LICENSE)
[![build](https://img.shields.io/github/actions/workflow/status/jqssun/android-ci/build.yml)](https://github.com/jqssun/android-ci/actions/workflows/build.yml)

A minimal build system to assemble [reproducible builds](https://reproducible-builds.org/) for a curated set of Android applications.

## Usage

To build an app, simply use:
```bash 
./build.sh [all|<application_id>]
```
Note that the releases published by GitHub Actions are for demonstration purposes only. They are only safe insofar as the build environment and sources are trusted. Building from source yourself is always preferred.

## Motivation

One hurdle for more widespread adoption of good FOSS apps, is the lack of readily available, consistently verifiable builds. A lot of the times despite availability of code/repository, attempting to actually compile from source can be a tedious and time-consuming task, sometimes even impossible.

This repository originally started off as a side project - it was a simple pipeline to routinely generate builds of commonly used apps, directly against their sources for personal use. Compared to conventional app repositories and marketplaces this approach offers several advantages, to name a few:

* it produces only and directly from source code with a consistent build environment, so most of the times you can be sure that the build is reproducible and verifiable
* it tracks HEAD of repository by default, and so you will not have to wait for the developer to publish a release to stay on the latest commit (much akin to the bleeding edge philosophy adopted by Arch Linux)
* the release builds use a custom signature such that you cannot accidentally install a version produced by another build system on top - the signature also stays the same across app versions so updating is a painless process
* it solves the headache of having to manually pull lots of dependencies of various versions just for a one-off build task that might not even work - the scripts perform all the necessary steps you need for a successful build

## Development

The `./app/` folder contains a collection of build scripts sorted by application IDs. These scripts essentially are instructions to the build system for how to modify the build environment/sources for subsequent compilation.

The actual build server is based on `fdroidserver` which provides the necessary tooling and cross-platform support for pre-build checks, packaging and signing. This allows the build system to work on both Linux and Darwin.


## License

The build scripts are licensed under GPL-3.0. Sources of the applications built using these scripts are intellectual property of their respective authors, and thus covered by their respective licenses.
