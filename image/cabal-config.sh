#!/bin/bash -eu

cabal get
sed -i "s|remote-repo:.*|remote-repo: stackage:http://www.stackage.org/alias/fpcomplete/unstable-ghc78-inclusive|" ~/.cabal/config