#!/usr/bin/env bash
set -o pipefail
# Pre-checks
[[ $# -lt 1 ]] && ( echo "No input file specified"; exit 1 )
[[ ! -s $1 ]] && ( echo "The input file is empty"; exit 1 )

input_file=$1
line=$(<"$input_file")

checksum=0
pos=0       # position in the new compact file
EOL=$(( ${#line} - 1)); if [[ $(( EOL / 2 )) -eq 1 ]]; then (( EOL-=1 )); fi
last_fileblock=${line:$EOL:1}

output=()

for (( i=0; i<=EOL; i++ )); do # i / 2 = file id
    if [[ $(( i % 2 )) -eq 0 ]]; then # file block
        id=$(( i / 2 ))
        if [[ $(( i / 2 )) -eq $EOL ]]; then blocklength="${line:$i:1}"; else blocklength=$last_fileblock; fi
        for _ in $(seq "$blocklength"); do # for the length of the file block; checksum += fileblock-id * position in compact file
            output+=("id: ${id}, pos: ${pos}")
            (( checksum += id * pos ))
            (( pos++ ))
        done
    else # empty space
        for _ in $(seq "${line:$i:1}"); do
            if [[ $last_fileblock -eq 0 ]]; then
                (( EOL-=2 ))
                last_fileblock="${line:$EOL:1}"
            fi
            id=$(( EOL / 2 ))
            output+=("id: ${id}, pos: ${pos}")
            (( checksum += id * pos ))
            (( pos++ ))
            (( last_fileblock--))
        done
        # for length of the empty space: if fileblock is 0, position -2; checksum += new_fileblock-id * position
    fi
done

echo $checksum
echo "${line}"
for item in "${output[@]}"; do
    echo "$item"
done