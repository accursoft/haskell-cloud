#!/bin/bash -eu

#download cabal
wget -O- https://hackage.haskell.org`wget -O- https://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#build
export EXTRA_CONFIGURE_OPTS="--ghc-option=-j"
./bootstrap.sh --no-doc
mv ~/.cabal/bin/cabal /usr/local/bin

#remove the packages installed by cabal-install and other cruft, as they might not be the best ones to use when we install the frameworks
rm -rf /cabal-install-* ~