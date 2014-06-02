#!/bin/bash -eu

# install prerequisites
yum install -y ghc make ncurses-devel gcc gmp-devel which zlib-devel
#which and zlib-devel are only needed later by cabal-install
#yum installing all the prerequisites in the same layer saves time (we won't need to contact the update sites again)
#and space (we won't bloat subsequent layers with changes to the rpm db)

#download ghc
curl -s http://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-src.tar.xz | tar xJ
cd ghc-*

#build
./configure

echo "V = 0
SRC_HC_OPTS = -O -H64m
HADDOCK_DOCS = NO
DYNAMIC_GHC_PROGRAMS = NO
GhcLibWays = v
GhcWithInterpreter = NO
GhcRTSWays = thr" > mk/build.mk

make -j$(nproc)
make install

#strip libraries and executables
cd /usr/local/lib/ghc*
find -name '*.a' -exec strip --strip-unneeded {} +
strip bin/*

#clean up bin
cd ../../bin
rm hp2ps runghc* ghc ghc-pkg
mv ghc-pkg-* ghcpkg
mv ghc-* ghc
mv ghcpkg ghc-pkg

#clean up
rm -rf /ghc-*
yum autoremove -y ghc make ncurses-devel
yum clean all

#switch on gold linker
#we can't do this earlier because the yum-installed ghc can't use it
echo 2 | alternatives --config ld
