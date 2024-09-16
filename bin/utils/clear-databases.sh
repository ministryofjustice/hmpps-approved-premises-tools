#!/bin/sh

echo "==> Clearing databases..."

rootpath="$(dirname "$0")/../../"
rm -rf "$rootpath/databases"
