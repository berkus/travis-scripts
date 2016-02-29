#!/usr/bin/env sh
set -x

if [ ! -f "$HOME/bin/ninja" ]; then
    git clone git://github.com/martine/ninja.git || exit 1
    cd ninja || exit 1
    git checkout release || exit 1
    ./bootstrap.py || exit 1
    mkdir -p $HOME/bin || exit 1
    cp ninja $HOME/bin/ || exit 1
else
    echo 'Using cached ninja.'
fi
