#!/bin/bash -eu

#download cabal
wget -nv -O- http://hackage.haskell.org`wget -nv -O- http://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#ca-certificates not installed
sed -i "s|https:|http:|g" bootstrap.sh

#build
export EXTRA_CONFIGURE_OPTS="--ghc-option=-j"
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