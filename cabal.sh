#!/bin/bash -eu

#download cabal
curl -s http://hackage.haskell.org`curl -s http://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#build
export EXTRA_CONFIGURE_OPTS=--ghc-option=-j
sed -i "s|{CURL} -L|{CURL} -Ls|g" bootstrap.sh
./bootstrap.sh --no-doc
mv ~/.cabal/bin/cabal /usr/local/bin

#generate default .cabal/config
cabal get
mkdir /.cabal
sed "
#replace hackage with stackage inclusive
s|remote-repo:.*|remote-repo: stackage:http://www.stackage.org/alias/fpcomplete/unstable-ghc78-inclusive|
s|/root||g" ~/.cabal/config >/.cabal/config

#remove the packages installed by cabal-install and other cruft, as they might not be the best ones to use when we install the frameworks
rm -rf /cabal-install-* ~