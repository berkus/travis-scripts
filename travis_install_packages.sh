#!/usr/bin/env sh

set -e
set -x

# if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = linux -o -z "$TRAVIS_OS_NAME" ]; then
    # Install missing or update outdated Ubuntu packages for Travis VM.
    #wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
    #sudo add-apt-repository -y 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise main'
    sudo add-apt-repository -y ppa:28msec/utils # Recent cmake
    sudo add-apt-repository -y ppa:shnatsel/dnscrypt # libsodium packages
    if [ "$CC" = gcc ]; then
        sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test # gcc-4.8 backport for clang-3.5
    fi
    sudo apt-get clean
    sudo apt-get update
    sudo apt-get install -q --fix-missing libpulse-dev cmake libssl-dev libsodium-dev

    # clang-3.4 is included by default on travis-ci nodes
    #if [ "$CC" = clang ]; then
    #    sudo apt-get install -q --fix-missing clang-3.6
    #fi

    # gcc-4.6 is included by default on travis-ci nodes, that's too old.
    if [ "$CC" = gcc ]; then
        sudo apt-get install -q --fix-missing gcc-4.8 g++-4.8
        sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20
        sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20
    fi
elif [ "$TRAVIS_OS_NAME" = osx ]; then
    xcode-select --install
    brew update
    brew install cmake libsodium
else
    echo "*** Unknown travis-os, not installing extra packages"
fi
