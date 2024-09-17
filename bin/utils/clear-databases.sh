#!/bin/sh

echo "==> Clearing databases..."

rootpath="$(dirname "$0")/../../"
rm -rf "$rootpath/databases"

docker compose -f "$rootpath/docker-compose.yml" down -v
