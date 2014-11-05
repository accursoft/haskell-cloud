#!/bin/bash -eu

[ "$1" == "assemble" ] && tar -C /tmp -xf -

exec /tmp/scripts/$1