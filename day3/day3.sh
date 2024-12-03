#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

mapfile -t lines < <(sed '/^$/d' "$input_file")

declare -a commands=()
regex='mul\([0-9]{1,3},[0-9]{1,3}\)'

for line in "${lines[@]}"; do
  matches=$(echo "$line" | grep -oP "$regex")
  if [[ -n $matches ]]; then
    while read -r match; do
      commands+=("$match")
    done <<< "$matches"
  fi
done

prod=0
for mul in "${commands[@]}"; do
    x=${mul#mul(}; x=${x%,*)}
    y=${mul#mul(*,}; y=${y%)}
    ((prod+=x*y))
done

echo $prod
