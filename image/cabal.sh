#!/bin/sh -eu

export EXTRA_CONFIGURE_OPTS="--disable-library-for-ghci"
export EXTRA_BUILD_OPTS="-j"

#download latest Cabal from hackage
curl https://hackage.haskell.org`curl https://hackage.haskell.org/package/Cabal | grep -o '/package/Cabal-[0-9.]*/Cabal-[0-9.]*.tar.gz'` | tar xz
cd Cabal-*
#build
ghc Setup -o Setup $EXTRA_BUILD_OPTS
./Setup configure $EXTRA_CONFIGURE_OPTS
./Setup build $EXTRA_BUILD_OPTS
./Setup install
cd ..

#download cabal-install
curl https://hackage.haskell.org`curl https://hackage.haskell.org/package/cabal-install | grep -o '/package/cabal-install-[0-9.]*/cabal-install-[0-9.]*.tar.gz'` | tar xz
cd cabal-install-*

#build
./bootstrap.sh --no-doc --sandbox
#we could use --bindir in EXTRA_CONFIGURE_OPTS, but bootstrap.sh would warn after successful installation
#The 'cabal' executable was not successfully installed into .cabal-sandbox/bin/
mv .cabal-sandbox/bin/cabal /usr/local/bin

#clean up
rm -r /Cabal-* \
      /cabal-install-* \
      ~/.cabal