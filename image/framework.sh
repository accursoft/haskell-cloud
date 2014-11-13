#!/bin/bash -eu

cabal update

case $1 in
  network)
    cabal install --global network
    provides="network"
    ;;
  mflow)
    cabal install --global cpphs
    cabal install --global MFlow
    provides="MFlow"
    ;;
  yesod)
    cabal install --global yesod yesod-bin alex happy esqueleto
    provides="yesod-[[:digit:]]\|    esqueleto"
    ;;
  snap)
    cabal install --global snap
    provides="snap"
    ;;
  scotty)
    cabal install --global scotty
    provides="scotty"
    ;;
  happstack)
    cabal install --global happy
    cabal install --global hsx2hs
    cabal install --global happstack-foundation
    provides="happstack-foundation"
    ;;
  *)
    echo Unknown build option $1
    exit 1
esac

mkdir /opt/sti
echo "ghc-`ghc --numeric-version`" >/opt/sti/provides
echo "cabal-install-`cabal --numeric-version`" >>/opt/sti/provides
ghc-pkg list | grep " $provides-[[:digit:]]" | cut -c5- >>/opt/sti/provides

#clean up
rm -rf ~/.cabal
