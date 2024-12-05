#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

declare -A rules # Dictionairy; rules[x]=(y) -> (y) are successors of x

while IFS='|' read -r x y; do
    rules["$x"]+="$y "
done < <(grep '|' "$input_file")

declare -a sequences

while IFS=',' read -r -a sequence; do
    sequences+=("$(IFS=','; echo "${sequence[*]}")")
done < <(grep -v '|' "$input_file" | sed '/^$/d')


sum=0

for seq in "${sequences[@]}"; do
    valid=true
    seen=()
    IFS=',' read -r -a update <<< "$seq"
    # For every page in the sequence, check if any of its successors have already been seen.
    # If so, the pages are not in the correct order.
    for page in "${update[@]}"; do
        for successor in ${rules["$page"]}; do
            if [[ " ${seen[*]} " =~ " $successor " ]]; then
                valid=false
                break 2
            fi
        done
        seen+=("$page")
    done
    [[ $valid == true ]] && ((sum+="${update[((${#update[@]}/2))]}"))
done

echo $sum