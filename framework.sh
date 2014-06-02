#!/bin/bash -eu

cabal update

case $1 in
  network)
    cabal install --global network
    echo "network" >/tmp/provides
    ;;
  mflow)
    cabal install --global MFlow
    echo "MFlow" >/tmp/provides
    ;;
  yesod)
    cabal install --global alex
    cabal install --global yesod-platform happy esqueleto
    echo "yesod-platform-\d|^esqueleto" >/tmp/provides
    ;;
  snap)
    cabal install --global snap
    echo "snap" >/tmp/provides
    ;;
  scotty)
    cabal install --global scotty
    echo "scotty" >/tmp/provides
    ;;
  happstack)
    cabal install --global happy
    cabal install --global hsx2hs
    cabal install --global happstack-foundation
    echo "happstack-foundation" >/tmp/provides
    ;;
  *)
    echo Unknown build option $1
    exit 1
esac

#remove references to non-existent documentation
find /usr/local/lib/ghc-*/package.conf.d -name '*.conf' -exec sed -i "
s|haddock-interfaces: .*|haddock-interfaces:|
s|haddock-html: .*|haddock-html:|" {} +

#clean up
rm -rf /.cabal
