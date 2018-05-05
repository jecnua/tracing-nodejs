#!/bin/bash

# Run shellcheck
while IFS= read -r -d '' file
do
  shellcheck "$file"
done <   <(find . -iname '*.sh' -not -path '*/\.*' -not -path './node_modules/*' -type f -print0)

# Lint travis
travis lint .travis.yml

# Validate npm config
validate-npm-package

# Validate docker
dockerlint

dgoss run --rm -d \
  jecnua/tracing-nodejs:dev-latest
