#!/usr/bin/env bash

##### Overview
#
# Synchronises secrets stored in Kubernetes with passwords in a One Password vault
#
# Pre-requisites
#
# 1. Install the one password cli (brew install 1password-cli) and authenticate
# 2. Install the github cli (brew install gh) and authenticate
#
# For secrets defined in kubernetes the following format is used:
#
#  MY_USER_1_USERNAME
#  MY_USER_1_PASSWORD
#
#### One Password
#
# A password will be created/updated in One Password with the following tag:
#
#  cas_managed/MY_USER_1_USERNAME
#
# Tags are used in One Password because they're returned when listing entries
# in a vault, so it's easy to find existing items. We could use the item name
# or title, but then entries couldn't be renamed to provide a more suitable
# description for users
#
#### Git Hub
#
# Entries will be created in github in the the following format
#
#  E2E_USER_MY_USER_1_USERNAME
#  E2E_USER_MY_USER_1_PASSWORD

set -e
set -o pipefail

K8S_NAMESPACE=hmpps-community-accommodation-dev
K8S_SECRET=hmpps-cas-test-users

ONEPASS_VAULT=CAS
ONEPASS_TAG=cas_managed

# shellcheck disable=SC2034
readonly AP_REPOS=(
  "hmpps-approved-premises-ui"
  "hmpps-approved-premises-api"
)

# shellcheck disable=SC2034
readonly CAS2_REPOS=(
  "hmpps-community-accommodation-tier-2-ui"
  "hmpps-community-accommodation-tier-2-bail-ui"
  "hmpps-approved-premises-api"
)

# shellcheck disable=SC2034
readonly CAS3_REPOS=(
  "hmpps-temporary-accommodation-ui"
  "hmpps-approved-premises-api"
)

# shellcheck disable=SC2034
readonly SAS_REPOS=(
  "hmpps-single-accommodation-service-ui"
  "hmpps-single-accommodation-service-api"
)

declare -Ar prefix_to_repos=(
  [AP]=AP_REPOS
  [CAS2]=CAS2_REPOS
  [CAS3]=CAS3_REPOS
  [SAS]=SAS_REPOS
)

sync_to_one_pass() {
  onepass_items_json=$1
  secret_prefix=$2
  username=$3
  password=$4

  echo "Syncing 1 password for ${secret_prefix}"
  echo ""

  onepass_tag="${ONEPASS_TAG}/${secret_prefix}"
      onepass_id=$(echo "$onepass_items_json" | jq -r "to_entries[] | .value | select(.tags | index(\"${onepass_tag}\") ) | .id")

      if [ -n "${onepass_id}" ];
      then
          onepass_password=$(op item get "$onepass_id" --vault $ONEPASS_VAULT --fields label=password --reveal)
          if [[ "$onepass_password" != "$password" ]]; then
              echo "Updating password for '${secret_prefix}'"
              op item edit "$onepass_id" "password=$password" --vault $ONEPASS_VAULT
          else
              echo "Password already up-to-date for '${secret_prefix}'"
          fi

      else
          echo "No onepassword entry for '${secret_prefix}', will create new entry in onepass"

          op item create \
              --category login \
              --title "$secret_prefix" \
              --vault $ONEPASS_VAULT \
              --tags "${ONEPASS_TAG}/${secret_prefix}" \
              --url https://sign-in-dev.hmpps.service.justice.gov.uk/ \
              username="$username" \
              password="$password"
      fi

}

sync_to_github() {
  local secret_prefix=$1
  local username=$2
  local password=$3
  local repo_prefix=${secret_prefix%%_*}
  local repo_array_name=${prefix_to_repos[$repo_prefix]}
  local repo

  echo "Syncing github for ${secret_prefix}"
  echo ""

  if [[ -z "$repo_array_name" ]]; then
    echo "No github repositories configured for secret prefix '${secret_prefix}' (repo group '${repo_prefix}')" >&2
    return 1
  fi

  local -n repos="$repo_array_name"

  for repo in "${repos[@]}"; do
    gh secret set --repo "ministryofjustice/${repo}" "E2E_USER_${secret_prefix}_USERNAME" --body "$username"
    gh secret set --repo "ministryofjustice/${repo}" "E2E_USER_${secret_prefix}_PASSWORD" --body "$password"
  done
}

onepass_items_json=$(op item list --vault ${ONEPASS_VAULT} --categories Login --tags ${ONEPASS_TAG} --format json)

secrets_json=$(kubectl get secrets $K8S_SECRET --namespace $K8S_NAMESPACE -o json | jq ".data | map_values(@base64d)")
secret_prefixes=$(echo "$secrets_json" | jq -r "to_entries[] | select(.key | endswith(\"USERNAME\")) | .key | capture(\"(?<prefix>.+?(?=_USERNAME))\") | .prefix")

for secret_prefix in $secret_prefixes; do

    echo ""
    echo "Syncing creds for '$secret_prefix'"
    echo ""

    username=$(echo "$secrets_json" | jq -r "to_entries[] | select(.key == \"""${secret_prefix}_USERNAME""\") | .value")
    password=$(echo "$secrets_json" | jq -r "to_entries[] | select(.key == \"""${secret_prefix}_PASSWORD""\") | .value")

    sync_to_one_pass "$onepass_items_json" "$secret_prefix" "$username" "$password"
    echo ""
    sync_to_github "$secret_prefix" "$username" "$password"

done
