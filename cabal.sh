#!/bin/bash -eu

# install prerequisites
yum install -y which zlib-devel

#download cabal
curl -s http://hackage.haskell.org`curl -s http://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#build
export EXTRA_CONFIGURE_OPTS=--ghc-option=-j
sed -i "s|{CURL} -L|{CURL} -Ls|g" bootstrap.sh
./bootstrap.sh --no-doc
mv /.cabal/bin/cabal /usr/local/bin

#clean up
#remove the packages installed by cabal-install, as they might not be the best ones to use with the frameworks
rm -rf /cabal-install-* /.cabal /.ghc
yum autoremove -y which zlib-devel
yum clean all
