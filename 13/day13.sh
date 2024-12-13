#!/usr/bin/env bash
set -o pipefail

[[ $# -lt 1 || ! -s $1 ]] && (
    echo "No input file specified or file is empty"
    exit 1
)

input_file=$1
mapfile -t lines < <(sed '/^$/d' "$input_file")

calculate_cost() { # a.k.a. brute-force 
    local ax=$1
    local ay=$2
    local bx=$3
    local by=$4
    local px=$5
    local py=$6

    local min_cost=99999999
    local found=false

    for ((i = 0; i <= 100; i++)); do
        for ((j = 0; j <= 100; j++)); do
            local x=$((i * ax + j * bx))
            local y=$((i * ay + j * by))
            if ((x == px && y == py)); then
                local cost=$((i * 3 + j))
                if ((cost < min_cost)); then
                    min_cost=$cost
                    found=true
                fi
            fi
        done
    done

    if [ "$found" = true ]; then
        echo $min_cost
    else
        echo "Not possible"
    fi
}

sum=0

for ((i = 0; i < ${#lines[@]}; i += 3)); do
    button_a=(${lines[i]//[^0-9 ]/})
    button_b=(${lines[i + 1]//[^0-9 ]/})
    prize=(${lines[i + 2]//[^0-9 ]/})

    ax=${button_a[0]}
    ay=${button_a[1]}
    bx=${button_b[0]}
    by=${button_b[1]}
    px=${prize[0]}
    py=${prize[1]}

    cost=$(calculate_cost $ax $ay $bx $by $px $py)
    if [[ "$cost" == "Not possible" ]]; then
        echo "Not possible to reach prize at ($px, $py)"
    else
        ((sum += cost))
        echo "Cost to reach prize at ($px, $py): $cost"
    fi
done

echo "Total cost: $sum"