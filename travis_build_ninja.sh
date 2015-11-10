#!/usr/bin/env sh

set -x

git clone git://github.com/martine/ninja.git || exit 1
cd ninja
git checkout release
./bootstrap.py || exit 1
cp ninja $HOME/bin/ || exit 1
