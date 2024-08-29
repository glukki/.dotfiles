#!/bin/sh
set -euo pipefail
IFS=$'\n\t'

needRestart=$(rad node status | grep -c "running" || true)

rad node stop

echo Making backup
tar -caf ~/radicle-backups_"$(date -Idate)".tar.gz --exclude control.sock -C "$(rad self --home)" .

echo
echo Old version: $(rad --version)

curl -sSf https://radicle.xyz/install | sh -s -- --no-modify-path

echo
echo New version: $(rad --version)
echo

if (( $needRestart > 0 )); then
  rad node start
fi
