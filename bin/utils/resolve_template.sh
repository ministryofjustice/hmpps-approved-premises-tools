resolve_template() {
  echo "==> Resolve Template"
  echo "Resolving template $1 to $2"

  secrets=$(kubectl get secrets hmpps-approved-premises-api --namespace hmpps-community-accommodation-dev -o json | jq ".data | map_values(@base64d)")
  for secret in $(echo "$secrets" | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
    # shellcheck disable=SC2163
    export "$secret"
  done

  rm -f "$2"
  envsubst < "$1" > "$2"
}
