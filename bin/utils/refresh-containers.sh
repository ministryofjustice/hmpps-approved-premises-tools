#!/bin/sh

"$(dirname "$0")/install-or-update-integration-services.sh"

echo "==> Refreshing containers..."

yq '.services[].image' "$(dirname "$0")/../../docker-compose.yml" | while read -r container; do docker pull "$container"; done

