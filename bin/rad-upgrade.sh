#!/bin/sh

echo Old version: $(rad --version)

needRestart=$(rad node status | grep "running")

rad node stop
curl -sSf https://radicle.xyz/install | sh

echo
echo New version: $(rad --version)

if [[ -n "$needRestart" ]]; then
  rad node start
fi
