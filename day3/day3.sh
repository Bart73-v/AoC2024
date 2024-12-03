#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

mapfile -t lines < <(sed '/^$/d' "$input_file")

declare -a commands=()
regex="mul\([0-9]{1,3},[0-9]{1,3}\)"
regex_p2="mul\([0-9]{1,3},[0-9]{1,3}\)|do\(\)|don't\(\)"

part_one() {
    for line in "${lines[@]}"; do
        matches=$(echo "$line" | grep -oP "$regex")
        if [[ -n $matches ]]; then
            while read -r match; do
            commands+=("$match")
            done <<< "$matches"
        fi
    done
}

part_two() {
    enabled=true
    for line in "${lines[@]}"; do
        matches=$(echo "$line" | grep -oP "$regex_p2")
        if [[ -n $matches ]]; then
            while read -r match; do
                if [[ "$match" = "do()" ]]; then
                    enabled=true
                elif [[ "$match" = "don't()" ]]; then
                    enabled=false
                elif [[ $enabled = true && "$match" =~ $regex ]]; then
                    commands+=("$match")
                fi
            done <<< "$matches"
        fi
    done
}

#part_one
part_two

prod=0
for mul in "${commands[@]}"; do
    x=${mul#mul(}; x=${x%,*)}
    y=${mul#mul(*,}; y=${y%)}
    ((prod+=x*y))
done

echo $prod