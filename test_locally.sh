#!/bin/bash

# Run shellcheck
while IFS= read -r -d '' file
do
  shellcheck "$file"
done <   <(find . -iname '*.sh' -not -path '*/\.*' -not -path './node_modules/*' -type f -print0)

# Test travis
travis lint .travis.yml

dgoss run --rm -d --net nodejs_tracing \
  jecnua/tracing-nodejs:dev-latest
