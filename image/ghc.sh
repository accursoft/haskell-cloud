#!/bin/sh -eu

# install prerequisites

dependencies="
  curl
  gcc
  libgmp-dev
  zlib1g-dev
  "
#zlib-dev is only needed later by cabal-install
#installing all the prerequisites in the same layer saves time (we won't need to contact the update sites again)
#and space (we won't bloat subsequent layers with changes to the package db)
  
build_dependencies="
  ghc
  make
  ncurses-dev
  xz-utils
  "

apt-get update
apt-get install -y perl-base $dependencies $build_dependencies

#download ghc
echo "silent
show-error" >>~/.curlrc
echo "Downloading GHC ..."
curl http://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-src.tar.xz | tar xJ
cd ghc-*

#build
./configure

echo "V = 0
SRC_HC_OPTS = -O -H64m
HADDOCK_DOCS = NO
DYNAMIC_GHC_PROGRAMS = NO
GhcLibWays = v
GhcRTSWays = thr" > mk/build.mk

make -j$(nproc)
make install

cd /usr/local/lib/ghc*
#strip is silent, tell the user what's happening
echo "Stripping libraries ..."
find -name '*.a' -print -exec strip --strip-unneeded {} +
echo "Stripping executables ..."
ls bin/*
strip bin/*

#clean up bin
cd ../../bin
rm hp2ps runghc* ghc ghci ghc-pkg
mv ghc-pkg-* ghcpkg
mv ghci-* ghci
mv ghc-* ghc
mv ghcpkg ghc-pkg

#clean up
apt-get purge --auto-remove -y $build_dependencies
echo "Yes, do as I say!" | apt-get purge perl-base
apt-get clean
cd /usr/share
rm -r /ghc-* /var/lib/apt/lists/* doc man locale