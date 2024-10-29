resolve_template() {
  echo "==> Resolve Template"
  echo "Resolving template $1 to $2"

  if ! command -v jq &> /dev/null
  then
      echo "Cannot find 'jq'. Please install using 'brew install jq'"
      exit 1
  fi

  secrets=$(kubectl get secrets hmpps-approved-premises-api --namespace hmpps-community-accommodation-dev -o json | jq ".data | map_values(@base64d)")
  for secret in $(echo "$secrets" | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
    # shellcheck disable=SC2163
    export "$secret"
  done

  rm -f "$2"
  envsubst < "$1" > "$2"
}
