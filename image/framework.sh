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
    $cabal happstack-foundation
    provides="happstack-foundation"
    ;;
  *)
    echo Unknown build option $1
    exit 1
esac

mkdir /opt/s2i
echo "ghc-`ghc --numeric-version`" >/opt/s2i/provides
echo "cabal-install-`cabal --numeric-version`" >>/opt/s2i/provides
ghc-pkg list | grep " $provides-[[:digit:]]" | cut -c5- >>/opt/s2i/provides

#clean up
rm -rf ~/.cabal
