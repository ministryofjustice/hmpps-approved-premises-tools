#!/bin/sh

set -e

echo "==> Clone or update hmpps-probation-integration-services ..."

integration_services_dir="hmpps-probation-integration-services"

cd "$(dirname "$0")/../.." || exit

if [ -d $integration_services_dir ]; then
  echo "==> Updating hmpps-probation-integration-services..."
  cd $integration_services_dir && git pull
else
  echo "==> Cloning hmpps-probation-integration-services..."
  git clone https://github.com/ministryofjustice/hmpps-probation-integration-services.git
fi
