#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

declare -a input=()
declare -i safe_reports=0

strictly_inc(){
    for (( i = 0; i < ${#input[@]}-1; i++ )); do
        if [[ ! ${input[i]} -lt ${input[i+1]} ]] || [[ $((${input[i+1]} - ${input[i]})) -gt 3 ]]; then
            return 1
        fi
    done
    return 0
}

strictly_dec(){
    for (( i = 0; i < ${#input[@]}-1; i++ )); do
        if [[ ! ${input[i]} -gt ${input[i+1]} ]] || [[ $((${input[i]} - ${input[i+1]})) -gt 3 ]]; then
            return 1
        fi
    done
    return 0
}

read_from_file() {
    while read -a input || [[ -n "$input" ]]; do
        if [[ ${input[0]} -gt ${input[1]} ]]; then 
            if strictly_dec; then safe_reports+=1 && echo "${input[@]}"; fi
        else 
            if strictly_inc; then safe_reports+=1 && echo "${input[@]}"; fi
        fi
	done < "$input_file"
}

read_from_file
echo $safe_reports