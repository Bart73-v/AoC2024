import sys

with open(sys.argv[1], "r") as file:
    for line in file:
        if line != '\n':
            arrangement = [int(x) for x in list(line.strip().split())]

def blink(arrangement):
    new_arrangement = []
    for stone in arrangement:
        if stone == 0:
            new_arrangement.append(1)
        elif len(str(stone)) % 2 == 0:
            str_stone = str(stone)
            new_arrangement.append(int(str_stone[:(len(str_stone)//2)]))
            new_arrangement.append(int(str_stone[(len(str_stone)//2):]))
        else:
            new_arrangement.append((stone*2024))
    return new_arrangement

for i in range(25):
    arrangement = blink(arrangement)
print(len(arrangement))