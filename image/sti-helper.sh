#!/bin/bash -eu

if [ "$1" == "assemble" ]; then
  tar -C /tmp -xf -
  mv /tmp/scripts/* /home/haskell/sti
fi

exec /home/haskell/sti/$1