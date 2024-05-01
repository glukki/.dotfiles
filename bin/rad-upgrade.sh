#!/bin/sh
set -euo pipefail
IFS=$'\n\t'

needRestart=$(rad node status | grep -c "running" || true)

rad node stop
tar czvf ~/radicle-backups_$(date +"%Y-%m-%d").tgz ~/.radicle

echo
echo Old version: $(rad --version)

curl -sSf https://radicle.xyz/install | sh

echo
echo New version: $(rad --version)
echo

if (( $needRestart > 0 )); then
  rad node start
fi
