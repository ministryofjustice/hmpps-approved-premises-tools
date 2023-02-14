#!/bin/sh

echo "==> Refreshing containers..."

yq '.services[].image' "$(dirname "$0")/../../docker-compose.yml" | while read -r container; do docker pull "$container"; done

rm -rf "$(dirname "$0")/community-api-db" && \
rm -rf "$(dirname "$0")/nomis-db"
