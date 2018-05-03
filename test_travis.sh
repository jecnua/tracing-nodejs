#!/bin/bash
# No need to expose any port :)
# shellcheck disable=SC1091

while IFS= read -r -d '' file
do
  shellcheck "$file"
done <   <(find . -iname '*.sh' -not -path '*/\.*' -type f -print0)
