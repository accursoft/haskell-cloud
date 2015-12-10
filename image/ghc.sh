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
curl https://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3-src.tar.xz | tar xJ
cd ghc-*

#hpc, hp2ps and runghc not needed
sed -i '/BUILD_DIRS += utils\/\(hpc\|runghc\|hp2ps\)/d' ghc.mk
#skip ghci libraries
sed -i '/"$$(ghc-cabal_INPLACE)" configure/s/$/ --disable-library-for-ghci/' rules/build-package-data.mk

#build
./configure --with-system-libffi
mv /tmp/build.mk mk

make -j$(nproc)
make install

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