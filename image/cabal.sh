#!/bin/sh -eu

#download cabal
curl https://hackage.haskell.org`curl https://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#build
export EXTRA_CONFIGURE_OPTS="--ghc-option=-j"
./bootstrap.sh --no-doc --sandbox
#we could use --bindir in EXTRA_CONFIGURE_OPTS, but bootstrap.sh would warn after successful installation
#The 'cabal' executable was not successfully installed into .cabal-sandbox/bin/
mv .cabal-sandbox/bin/cabal /usr/local/bin

#remove the sandbox
rm -rf /cabal-install-* ~/.cabal