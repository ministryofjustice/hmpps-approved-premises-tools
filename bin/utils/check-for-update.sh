compare_revs() {
  a="$(git rev-parse "$1")"
  b="$(git rev-parse "$2")"
  [ "$a" = "$b" ]
}

is_main() {
  branch="$(git rev-parse --abbrev-ref HEAD)"
  [ "$branch" = "main" ]
}

echo "==> Checking for updates..."

current_dir="$(pwd)"
cd "$(dirname "$0")" || exit 1

if ! is_main; then
  echo "Current branch is not 'main', skipping update checks."
  cd "$current_dir" || exit 1
  exit 1
fi

git fetch > /dev/null 2>&1

if compare_revs "main" "origin/main"; then
  echo "Current version of ap-tools is up-to-date."
  cd "$current_dir" || exit 1
  exit 1
fi

echo "New version of ap-tools found, updating."
if git pull > /dev/null 2>&1; then
  echo "Could not update ap-tools automatically. No changes have been made."
  cd "$current_dir" || exit 1
  exit 1
fi

echo "Updated to latest version of ap-tools."
cd "$current_dir" || exit
