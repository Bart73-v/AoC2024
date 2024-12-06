#!/usr/bin/env bash
set -o pipefail
declare -A map
declare -a lines
declare -i positions
declare -i guard_i
declare -i guard_j
declare -a guard=("^" "v" "<" ">")
declare -i bound_i
declare -i bound_j
terminate() { # Because I'm a professional 8-)
	local msg="${1}"
	local code="${2}"
	echo "Error: ${msg}" >&2
	exit "${code:-1}"
}
usage() {
	cat <<EOF
Usage: day6.sh [FILE]
    Returns the number of distinct positions visited by the guard.
    Arguments:
        FILE: A text file containing current position as described in Day 6: Guard Gallivant
EOF
}

[[ $# -lt 1 ]] && ( usage; terminate "No input file specified" 2 )
[[ ! -s $1 ]] && ( usage; terminate "The input file is empty" 3 )


input_file=$1
mapfile -t lines < <(sed '/^$/d' "$input_file")

# Create associative array (i.e. matrix)
for (( i=0; i < "${#lines[@]}"; i++ )); do
    for (( j=0; j < "${#lines[0]}"; j++ )); do
        char="${lines[i]:$j:1}"
        if [[ "${guard[*]}" == *"$char"* ]]; then
            guard_i=$i
            guard_j=$j
        fi
        map["$i","$j"]="${lines[i]:$j:1}"
    done
done
bound_i="${#lines[@]}"
bound_j="${#lines[0]}"

print_map() {
    for (( i=0; i < "${#lines[@]}"; i++ )); do
        line=""
        for (( j=0; j < "${#lines[0]}"; j++ )); do
            char="${map["$i","$j"]}"
            line="${line}${char}"
        done
        echo "$line"
    done
}

next_move() {
    new_i=$guard_i
    new_j=$guard_j
    case "${map["$guard_i","$guard_j"]}" in
        "^")
            (( new_i-=1 )); [[ new_i -lt 0 || new_i -eq $bound_i ]] && done=true
            if [ "${map["$new_i","$guard_j"]}" = "#" ]; then 
                map["$guard_i","$guard_j"]=">"
            else
                map["$guard_i","$guard_j"]="X"
                (( guard_i-=1 ))
                if [ $done = "false" ]; then map["$guard_i","$guard_j"]="^"; fi
            fi
        ;;
        "v")
            (( new_i+=1 )); [[ new_i -lt 0 || new_i -eq $bound_i ]] && done=true
            if [ "${map["$new_i","$guard_j"]}" = "#" ]; then 
                map["$guard_i","$guard_j"]="<"
            else
                map["$guard_i","$guard_j"]="X"
                (( guard_i+=1 ))
                if [ $done = "false" ]; then map["$guard_i","$guard_j"]="v"; fi
            fi
        ;;
        ">")
            (( new_j+=1 )); [[ new_j -lt 0 || new_j -eq $bound_j ]] && done=true
            if [ "${map["$guard_i","$new_j"]}" = "#" ]; then 
                map["$guard_i","$guard_j"]="v"
            else
                map["$guard_i","$guard_j"]="X"
                (( guard_j+=1 ))
                if [ $done = "false" ]; then map["$guard_i","$guard_j"]=">"; fi
            fi
        ;;
        "<")
            (( new_j-=1 )); [[ new_j -lt 0 || new_j -eq $bound_j ]] && done=true
            if [ "${map["$guard_i","$new_j"]}" = "#" ]; then 
                map["$guard_i","$guard_j"]="^"
            else
                map["$guard_i","$guard_j"]="X"
                (( guard_j-=1 ))
                if [ $done = "false" ]; then map["$guard_i","$guard_j"]="<"; fi
            fi
        ;;
    esac
}

count_positions() {
    for (( i=0; i < "${#lines[@]}"; i++ )); do
        for (( j=0; j < "${#lines[0]}"; j++ )); do
            if [ "${map[$i,$j]}" = "X" ]; then ((positions++)); fi
        done
    done
}


done=false
while [ $done = "false" ]; do
    next_move
done
count_positions
echo $positions