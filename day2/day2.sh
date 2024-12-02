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
    while read -a input || [[ -n "${input[1]}" ]]; do
        if [[ ${input[0]} -gt ${input[1]} ]]; then 
            if strictly_dec; then safe_reports+=1; fi
        else 
            if strictly_inc; then safe_reports+=1; fi
        fi
	done < "$input_file"
}

read_from_file_p2() {
    while read -a input || [[ -n "${input[1]}" ]]; do
        safe=false
        for (( i - 0; i < ${#input[@]}; i++ )); do
            input=("${input[@]:$(($i + 1))}")
            echo "${input[@]}"
            if [[ ${input[0]} -gt ${input[1]} ]]; then 
                if strictly_dec; then safe=true; fi
            else 
                if strictly_inc; then safe=true; fi
            fi
        done
        if $safe; then safe_reports+=1; fi
	done < "$input_file"
}

read_from_file_p2
#(( safe_reports-=1 )) #something something bash newline
echo $safe_reports