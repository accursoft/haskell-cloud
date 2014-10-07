#!/bin/bash -eu

# install prerequisites
apt-get update
apt-get install -y \
  gcc \
  ghc \
  libgmp-dev \
  make \
  ncurses-dev \
  wget \
  zlib1g-dev
#zlib-dev is only needed later by cabal-install
#installing all the prerequisites in the same layer saves time (we won't need to contact the update sites again)
#and space (we won't bloat subsequent layers with changes to the package db)

#download ghc
wget -qO- http://www.haskell.org/ghc/dist/7.8.3/ghc-7.8.3-src.tar.xz | tar xJ
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

#switch on gold linker
#we can't do this earlier because the apt-installed ghc can't use it
apt-get install binutils-gold

#strip libraries and executables
cd /usr/local/lib/ghc*
find -name '*.a' -exec strip --strip-unneeded {} +
strip bin/*

#clean up bin
cd ../../bin
rm hp2ps runghc* ghc ghci ghc-pkg
mv ghc-pkg-* ghcpkg
mv ghci-* ghci
mv ghc-* ghc
mv ghcpkg ghc-pkg

#clean up
apt-get purge --auto-remove -y \
  ghc \
  make \
  ncurses-dev
apt-get clean
rm -rf /ghc-* /var/lib/apt/lists/*