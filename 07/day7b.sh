#!/usr/bin/env bash
set -o pipefail

# Pre-checks
[[ $# -lt 1 ]] && ( echo "No input file specified"; exit 1 )
[[ ! -s $1 ]] && ( echo "The input file is empty"; exit 1 )

echo "This will take years to compute"; exit 1

input_file=$1
mapfile -t lines < <(sed '/^$/d' "$input_file")

recursive_compute() {
    value=$1
    sum=$2
    read -r -a numbers <<<"${3}"
    if [[ value -eq sum && -z ${numbers[*]} ]]; then 
        echo "true"
    elif [[ -z ${numbers[*]} ]]; then
        echo "false"
    else
        add=$(recursive_compute "$value" "$(( $sum + ${numbers[0]} ))" "${numbers[*]:1}")
        mul=$(recursive_compute "$value" "$(( $sum * ${numbers[0]} ))" "${numbers[*]:1}")
        con=$(recursive_compute "$value" "$sum${numbers[0]}" "${numbers[*]:1}")
        if [[ $add == "true" || $mul == "true" || $con == "true" ]]; then echo "true"; else echo "false"; fi
    fi
}

calibration_result=0
i=0
for line in "${lines[@]}"; do
    echo "line: $i, total: $calibration_result"
    ((i++))
    value=${line%:*}
    read -r -a numbers <<< "${line#*: }"
    if [[ "$(recursive_compute "$value" "${numbers[0]}" "${numbers[*]:1}")" == "true" ]]; then
        calibration_result=$(bc <<< "${calibration_result}+${value}")
    fi
done

echo "$calibration_result"