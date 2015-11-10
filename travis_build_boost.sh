#!/usr/bin/env sh
# Build a 64-bit c++11 libc++ based boost libraries we need for linux.
# Based on brew recipe.
set -x
set -e
BOOST_VER=1.59.0

if [ ! -d "$HOME/boost/lib64" ]; then
    # us-east mirrors for travis: hivelocity, colocrossing
    wget -O boost_$BOOST_VER.tar.bz2 http://sourceforge.net/projects/boost/files/boost/$BOOST_VER/boost_${BOOST_VER//./_}.tar.bz2/download?use_mirror=colocrossing
    tar xjf boost_$BOOST_VER.tar.bz2
    cd boost_$BOOST_VER
    # FIXME: this is only linux and only clang, need more flexible setup (osx, gcc, 32 bit?)
    cat <<EOF > user-config.jam
    using clang-linux : : clang++ ;
EOF
    export BOOST_DIR=$HOME/boost
    ./bootstrap.sh --prefix=$BOOST_DIR --libdir=$BOOST_DIR/lib64 \
        --with-toolset=clang \
        --with-libraries=system,date_time,program_options,test,thread,filesystem \
        --without-icu
    ./b2 --prefix=$BOOST_DIR --libdir=$BOOST_DIR/lib64 -d0 -j6 --layout=system \
        --user-config=user-config.jam threading=multi install toolset=clang \
        cxxflags=-std=c++11 cxxflags=-stdlib=libc++ cxxflags=-fPIC cxxflags=-m64 \
        linkflags=-stdlib=libc++ linkflags=-m64
    fi
else
    echo 'Using cached boost directory.'
fi
