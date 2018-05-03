#!/bin/bash
# No need to expose any port :)
# shellcheck disable=SC1091

while IFS= read -r -d '' file
do
  shellcheck "$file"
done <   <(find . -iname '*.sh' -not -path '*/\.*' -type f -print0)

dgoss run --rm -d --net nodejs_tracing \
  jecnua/tracing-nodejs:dev-latest
