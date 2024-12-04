#!/usr/bin/env bash
set -o pipefail

input_file=$1
[[ -z $1 ]] && (echo "No input file specified."; exit 1)

mapfile -t lines < <(sed '/^$/d' "$input_file")

x_bound="${#lines[0]}"
y_bound="${#lines[y]}"

# add vertical lines
for ((j=0; j < $x_bound; j++)); do
    line=""
    for ((i=0; i < $y_bound; i++)); do
        line="${line}$(echo "${lines[$i]:$j:1}")"
    done
    lines=("${lines[@]}" "$line")
done

# add diagonal lines - right to left
for ((j=3; j < $x_bound; j++)); do
    line="${lines[0]:$j:1}"
    J=$j
    for ((i=1; i < $y_bound; i++)); do
        ((J--))
        if [[ $J -lt 0 ]]; then break; fi
        line="${line}$(echo "${lines[$i]:$J:1}")"
    done
    lines=("${lines[@]}" "$line")
done

# add diagonal lines - right to left - which do not start on the first line
for ((j=$x_bound; j < $x_bound*2-4; j++)); do
    line=""
    J=$j
    for ((i=0; i < $y_bound; i++)); do
        if [[ $J -gt $x_bound ]]; then ((J--)); continue; fi
        line="${line}$(echo "${lines[$i]:$J:1}")"
        ((J--))
    done
    lines=("${lines[@]}" "$line")
done

# add diagonal lines - left to right
for ((j=0; j < $x_bound-3; j++)); do
    line="${lines[0]:$j:1}"
    J=$j
    for ((i=1; i < $y_bound; i++)); do
        ((J++))
        if [[ $J -eq $x_bound ]]; then break; fi
        line="${line}$(echo "${lines[$i]:$J:1}")"
    done
    lines=("${lines[@]}" "$line")
done

# add diagonal lines - left to right - which do not start on the first line
for ((j=0-$x_bound+4; j < 0; j++)); do
    line=""
    J=$j
    for ((i=0; i < $y_bound; i++)); do
        if [[ $J -lt 0 ]]; then ((J++)); continue; fi
        line="${line}$(echo "${lines[$i]:$J:1}")"
        ((J++))
    done
    lines=("${lines[@]}" "$line")
done


xmas=0

for line in "${lines[@]}"; do
    ((xmas+=$(echo "$line" | grep -o "XMAS" | wc -l)))
    ((xmas+=$(echo "$line" | grep -o "SAMX" | wc -l)))
done

echo $xmas