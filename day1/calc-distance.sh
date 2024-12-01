#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

declare -a LEFT_ARRAY=()
declare -a RIGHT_ARRAY=()
declare -i distance=0
declare -i similarity=0

sort_arrays() {
	IFS=$'\n' LEFT_ARRAY=($(sort <<< "${LEFT_ARRAY[*]}")); unset IFS
	IFS=$'\n' RIGHT_ARRAY=($(sort <<< "${RIGHT_ARRAY[*]}")); unset IFS
}

read_from_file() {
	while read -r x y || [[ -n "$x" ]]; do
		LEFT_ARRAY+=("$x")
		RIGHT_ARRAY+=("$y")
	done < "$input_file"
}

get_distance(){
	for i in $(seq 0 $(( ${#LEFT_ARRAY[@]} - 1 ))); do
		distance+=$(( ${LEFT_ARRAY[i]} < ${RIGHT_ARRAY[i]} ? ${RIGHT_ARRAY[i]} - ${LEFT_ARRAY[i]} : ${LEFT_ARRAY[i]} - ${RIGHT_ARRAY[i]} ))
	done
}

get_similarity() {
	for (( i = 0; i < ${#LEFT_ARRAY[@]}; i++)); do
		similarity+=$(( ${LEFT_ARRAY[i]} * $(grep -o "${LEFT_ARRAY[i]}" <<< "${RIGHT_ARRAY[*]}" | wc -l) ))
	done
}

read_from_file
sort_arrays

# part 1
get_distance
echo $distance

# part 2
get_similarity
echo $similarity