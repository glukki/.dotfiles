#!/bin/sh

echo Initial version: $(rad --version)

curl -sSf https://radicle.xyz/install | sh

echo
echo Resulting version: $(rad --version)
