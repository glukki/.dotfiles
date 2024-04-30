#!/bin/sh
set -euo pipefail
IFS=$'\n\t'

oldVersion=$(rad --version)
needRestart=$(rad node status | grep "running")

rad node stop
tar czvf ~/radicle-backups_$(date +"%Y-%m-%d").tgz ~/.radicle
curl -sSf https://radicle.xyz/install | sh

echo
echo Old version: $oldVersion
echo New version: $(rad --version)

if [[ -n "$needRestart" ]]; then
  rad node start
fi
