#!/usr/bin/env bash
set -e
# shellcheck disable=SC3040
set -o pipefail

#
# Note! this script is not currently used. If it is, configuration needs to come from a location
# other than LOCAL_CAS_UI_PATH, which is no longer required
#

# Override the properties we have in target with anything included in the .env file in the local UI repo
override_ui_props_with_local_ui_props() {
  echo "==> Override the properties we have in .env.ui file with anything included in the .env file in the local UI repo"

  target_env=$1 ; shift
  priority_env="${LOCAL_CAS_UI_PATH}/.env"
  merged_env=".env.merged"

  echo "Overriding $target_env properties with $priority_env properties"

  # Extract keys from priority file
  priority_keys=$(cut -d '=' -f 1 "$priority_env")

  # Remove lines from .env that are overridden
  cp "$target_env" "$merged_env"
  for key in $priority_keys; do
      # Remove lines with matching key (supports optional whitespace)
      # shellcheck disable=SC1087
      sed -i '' "/^$key[[:space:]]*=/d" "$merged_env"
  done

  # Append all priority variables to output
  cat "$priority_env" >> "$merged_env"


  # Replace the content $$target_env file with the content of the merged .env file
  cp "$merged_env" "$target_env"

  # Clean up
  rm "$merged_env"

  echo "Merged .env file created at $target_env"

  # remove comments from the resultant file
  # -i '' is required for mac os, see https://stackoverflow.com/questions/26081375
  sed -i '' '/^#/d' "$target_env"
}
