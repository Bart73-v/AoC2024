#!/usr/bin/env bash
set -o pipefail
# Pre-checks
[[ $# -lt 1 ]] && ( echo "No input file specified"; exit 1 )
[[ ! -s $1 ]] && ( echo "The input file is empty"; exit 1 )

input_file=$1
mapfile -t lines < <(sed '/^$/d' "$input_file")

declare -A map
declare -i bound_i=${#lines[@]}
declare -i bound_j=${#lines[0]}

# Create associative array containing all the satellites
for ((i=0; i<$bound_i; i++)); do
    for ((j=0; j<bound_j; j++)); do
        char="${lines[i]:j:1}"
        if [[ $char == "." ]]; then
            continue
        elif [[ -n "${map[$char]}" ]]; then
            map[$char]+=" ($i,$j)"
        else
            map[$char]="($i,$j)"
        fi
    done    
done

print_map(){
    for key in "${!map[@]}"; do
        echo "$key: ${map[$key]}"
    done
}

declare -a antinodes

create_antinodes() {
    ai=$1
    aj=$2
    bi=$3
    bj=$4
    antinode_1=""
    antinode_2=""
    (( ci = ai + (ai - bi)))
    (( cj = aj + (aj - bj)))
    (( di = bi + (bi - ai)))
    (( dj = bj + (bj - aj)))
    if [[ ! $ci -lt 0 && ! $cj -lt 0 && $ci -lt $bound_i && $cj -lt $bound_j ]]; then
        antinode_1="$ci,$cj"
    fi
    if [[ ! $di -lt 0 && ! $dj -lt 0 && $di -lt $bound_i && $dj -lt $bound_j ]]; then
        antinode_2="$di,$dj"
    fi
    echo "$antinode_1 $antinode_2"
}

for freq_locations in "${map[@]}"; do
    read -ra locations <<< "${freq_locations[@]}"
    for ((i=0; i<"${#locations[@]}"; i++)); do
        for ((j=i+1; j<"${#locations[@]}"; j++)); do
            loc1="${locations[$i]}" loc1i=${loc1#(}; loc1j=${loc1#*,}
            loc2="${locations[$j]}" loc2i=${loc2#(}; loc2j=${loc2#*,}
            ai=${loc1i%,*}; aj=${loc1j%)}; bi=${loc2i%,*}; bj=${loc2j%)}
            read -ra antinode <<< "$(create_antinodes "$ai" "$aj" "$bi" "$bj")"
            if [ "${#antinode[@]}" -gt 0 ]; then
                for node in "${antinode[@]}"; do
                    antinodes+=("$node")
                done
            fi
        done
    done
done

echo "$(for antinode in "${antinodes[@]}"; do echo "${antinode}"; done | sort -u | wc -l)"