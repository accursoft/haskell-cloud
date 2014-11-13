#!/bin/bash -eu

if [ "$1" == "assemble" ]; then
  tar -C /tmp -x
  mkdir ~/sti
  mv /tmp/scripts/* ~/sti
fi

exec ~/sti/$1