#!/usr/bin/env bash
set -o pipefail
# set -e

[[ $# -lt 1 || ! -s $1  ]] && ( echo "No input file specified or file is empty"; exit 1 )


input_file=$1
mapfile -t lines < <(sed '/^$/d' "$input_file")

declare -A grid
declare -A visited
declare -A regions
declare -i region_id=0

rows=${#lines[@]}
cols=${#lines[0]}

# Load the grid into an associative array
for (( i=0; i<rows; i++ )); do
    for (( j=0; j<cols; j++ )); do
        grid["$i,$j"]="${lines[$i]:$j:1}"
        visited["$i,$j"]=0
    done
done

flood_fill() {
    local x=$1
    local y=$2
    local char=$3
    local current_region=$4

    # Boundary and visited check
    if (( x < 0 || x >= rows || y < 0 || y >= cols )) || [[ ${visited["$x,$y"]} -eq 1 ]] || [[ ${grid["$x,$y"]} != "$char" ]]; then
        return
    fi

    # Mark the cell as visited and add to the current region
    visited["$x,$y"]=1
    regions["$char,$current_region"]+="($x,$y) "

    # Recursively flood-fill in all four directions
    flood_fill $((x-1)) $y "$char" "$current_region"
    flood_fill $((x+1)) $y "$char" "$current_region"
    flood_fill $x $((y-1)) "$char" "$current_region"
    flood_fill $x $((y+1)) "$char" "$current_region"
}

# Main logic to identify regions
for (( i=0; i<rows; i++ )); do
    for (( j=0; j<cols; j++ )); do
        char=${grid["$i,$j"]}
        if [[ ${visited["$i,$j"]} -eq 0 ]]; then
            # Start a new region
            region_id+=1
            flood_fill "$i" "$j" "$char" "$region_id"
        fi
    done
done

# Print the regions
print_regions() {
    for key in "${!regions[@]}"; do
        echo "$key: ${regions[$key]}"
    done
}

get_neighbours(){
    local region=$1
    local point=$2
    x=${point#(}; x=${x%,*}
    y=${point#*,}; y=${y%)}
    neighbours=("($((x-1)),$y)" "($((x+1)),$y)" "($x,$((y-1)))" "($x,$((y+1)))")
    output=0

    for neighbor in "${neighbours[@]}"; do
        if [[ " ${region[*]} " == *" $neighbor "* ]]; then
            (( output++ ))
        fi
    done
    
    echo "$output"
}

part_one(){
    total=0

    for key in "${!regions[@]}"; do
        area=0
        adjacent=0
        for point in ${regions[$key]}; do
            (( area++ ))
            adjacents=$( get_neighbours "${regions[$key]}" "$point" )
            (( adjacent += adjacents ))
        done
        (( total += area * (4 * area - adjacent)))
    done

    echo "$total"
}

# print_regions
part_one