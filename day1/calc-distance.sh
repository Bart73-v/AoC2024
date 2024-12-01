#!/usr/bin/env bash
set -o pipefail

input_file=./test-input.txt
#[[ -z $1 ]] && echo "No input file specified."; exit 1

declare -a LEFT_ARRAY=()
declare -a RIGHT_ARRAY=()

sort_arrays() {
	LEFT_ARRAY=($(for i in "${LEFT_ARRAY[@]}"; do echo "$i"; done | sort -n))
	RIGHT_ARRAY=($(for i in "${RIGHT_ARRAY[@]}"; do echo "$i"; done | sort -n))
}

read_from_file() {
	while read -r x y; do
		LEFT_ARRAY+=("$x")
		RIGHT_ARRAY+=("$y")
	done < "$input_file"
}

get_distance(){
	local distance=0
	
	echo distance
}
read_from_file
sort_arrays

echo "Array Left: ${LEFT_ARRAY[@]}"
echo "Array Right: ${RIGHT_ARRAY[@]}"

