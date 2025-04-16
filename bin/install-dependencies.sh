#!/usr/bin/env bash

if command -v brew > /dev/null 2>&1
then
  echo "==> Installing dependencies..."
  cd "$(dirname "$0")/.." || exit
  brew bundle > /dev/null 2>&1
fi

echo "Dependencies installed"
