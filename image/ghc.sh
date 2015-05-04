#!/bin/sh -eu

export DEBIAN_FRONTEND=noninteractive

# install prerequisites

dependencies="
  ca-certificates
  curl
  gcc
  libffi-dev
  libgmp-dev
  passwd
  zlib1g-dev
  "
#zlib-dev is only needed later by cabal-install
#installing all the prerequisites in the same layer saves time (we won't need to contact the update sites again)
#and space (we won't bloat subsequent layers with changes to the package db)
#passwd is used by the dockerfile for creating users
#we could save about 3Mb by creating users in this script and making it a build dependency instead
  
build_dependencies="
  ghc
  make
  ncurses-dev
  xz-utils
  "

apt-get update
apt-get install -y --no-install-recommends $dependencies $build_dependencies

#download ghc
echo "silent
show-error" >>~/.curlrc
echo "Downloading GHC ..."
curl https://downloads.haskell.org/~ghc/7.10-latest/ghc-7.10.1-src.tar.xz | tar xJ
cd ghc-*

#hpc and hp2ps not needed
#runghc does not work with non-interactive build
sed -i '/BUILD_DIRS += utils\/\(hpc\|runghc\|hp2ps\)/d' ghc.mk

#build
./configure --with-system-libffi

echo "V = 0
GhcHcOpts =
SRC_HC_OPTS = -O -H64m
HADDOCK_DOCS = NO
DYNAMIC_GHC_PROGRAMS = NO
SplitObjs = NO
GhcWithInterpreter = NO
GhcLibWays = v
GhcRTSWays = thr" > mk/build.mk

make -j$(nproc)
make install

#clean up bin
cd /usr/local/bin
rm ghc ghc-pkg
mv ghc-pkg-* ghcpkg
mv ghc-* ghc
mv ghcpkg ghc-pkg

#remove ghc-bundled Cabal, will install latest with cabal-install
ghc-pkg unregister Cabal

#clean up
apt-get purge --auto-remove -y $build_dependencies
/opt/post-apt
rm -r /ghc-* \
      /usr/local/lib/ghc-*/Cabal_* \
      /usr/local/share/doc/ghc/html/libraries/Cabal-*

#strip
cd /usr/local/lib/ghc*
#tell the user what's happening
echo "Stripping libraries ..."
find -name '*.a' -print -exec strip --strip-unneeded {} +
echo "Stripping executables ..."
ls bin/*
strip bin/*