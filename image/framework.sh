#!/bin/sh -eu

cabal="cabal install --global --disable-library-for-ghci"

cabal update

case $1 in
  network)
    $cabal network
    provides="network"
    ;;
  mflow)
    $cabal cpphs
    $cabal MFlow
    provides="MFlow"
    ;;
  yesod)
    $cabal yesod esqueleto
    provides="yesod-[[:digit:]]\|    esqueleto"
    ;;
  snap)
    $cabal snap
    provides="snap"
    ;;
  scotty)
    $cabal scotty
    provides="scotty"
    ;;
  happstack)
    $cabal happy
    $cabal hsx2hs
    $cabal happstack-foundation
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
