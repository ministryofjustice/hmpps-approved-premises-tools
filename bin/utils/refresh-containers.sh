#!/bin/sh

echo "==> Refreshing containers..."

yq '.services[].image' "$(dirname "$0")/../../docker-compose.yml" | while read -r container; do docker pull "$container"; done

rootpath="$(dirname "$0")/../../"
rm -rf "$rootpath/community-api-db" && \
rm -rf "$rootpath/nomis-db"
