#!/usr/bin/env bash
set -e
# shellcheck disable=SC3040
set -o pipefail

# Override the properties we have .env.casx-ui.template with entries in the local UI project's .env file
override_ui_props_with_local_ui_props() {
  target_env=$1
  priority_env=$2
  merged_env="/tmp/.env.merged"

  echo ""
  echo "==> Merging $priority_env into $target_env"

  # Extract keys from priority file
  priority_keys=$(cut -d '=' -f 1 "$priority_env")

  echo "Keys to add/update are $priority_keys"

  # Remove lines from .env that are overridden
  cp "$target_env" "$merged_env"
  for key in $priority_keys; do
      # Remove lines with matching key (supports optional whitespace)
      # shellcheck disable=SC1087
      sed -i '' "/^$key[[:space:]]*=/d" "$merged_env"
  done

  # add new lines before adding new values
  # shellcheck disable=SC2129
  echo >> "$merged_env"
  echo >> "$merged_env"

  # Append all priority variables to output
  cat "$priority_env" >> "$merged_env"

  # Replace the content $$target_env file with the content of the merged .env file
  cp "$merged_env" "$target_env"

  # Clean up
  rm "$merged_env"

  # remove comments from the resultant file
  # -i '' is required for mac os, see https://stackoverflow.com/questions/26081375
  sed -i '' '/^#/d' "$target_env"
}
