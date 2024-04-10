#!/bin/sh

integration_services_dir="hmpps-probation-integration-services"

cd "$(dirname "$0")/../.." || exit

if [ -d $integration_services_dir ]; then
  echo "==> Updating hmpps-probation-integration-services..."
  cd $integration_services_dir && git fetch > /dev/null 2>&1
else
  echo "==> Cloning hmpps-probation-integration-services..."
  git clone git@github.com:ministryofjustice/hmpps-probation-integration-services.git
fi