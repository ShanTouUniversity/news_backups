#!/usr/bin/env bash
set -euxo pipefail

DOMAIN="news.shantou.university"

cleanup() {
  rm -rf files/ posts/ settings/
}

download() {
  ARCHIVE_PATH="all.tar.xz"
  curl --proto "=https" --tlsv1.2 -sSf \
    -H "Authorization: Bearer $FX_PASSWORD" \
    https://$DOMAIN/api/download/all.tar.xz > "$ARCHIVE_PATH"

  tar --verbose -xf "$ARCHIVE_PATH"
  rm "$ARCHIVE_PATH"
}

commit() {
  if [ -n "$(git status --porcelain)" ]; then
    git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
    git config --global user.name "$GITHUB_ACTOR"

    git add .
    git commit -m '[bot] backup'
    git push
  fi
}

if [[ "$1" == "cleanup" ]]; then
  cleanup
elif [[ "$1" == "download" ]]; then
  download
elif [[ "$1" == "commit" ]]; then
  commit
fi