import sys

arrangement = list(map(int, open(sys.argv[1]).readline().strip().split()))

cache = {}

def blink(stone, blinks):
    if blinks == 0:
        return 1
    elif (stone, blinks) in cache:
        return cache[(stone, blinks)]
    elif stone == 0:
        output = blink(1, blinks - 1)
    elif len(str_stone := str(stone)) % 2 == 0:
        output = blink(int(str_stone[:len(str_stone)//2]), blinks - 1) + blink(int(str_stone[len(str_stone)//2:]), blinks - 1)
    else: 
        output = blink(stone * 2024, blinks - 1)
    cache[(stone,blinks)] = output
    return output

part_1 = 0
part_2 = 0
for stone in arrangement:
    part_1 += blink(stone,25)
    part_2 += blink(stone, 75)
print("Part 1: " + str(part_1))
print("Part 2: " + str(part_2))