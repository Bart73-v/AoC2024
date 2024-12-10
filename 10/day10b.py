import sys
import numpy as np

directions = [(1,0),(-1,0),(0,1),(0,-1)]

def pad_input(input):
    output=[]
    output.append(['#'] * (len(input[0]) + 2))
    for line in input:
        output.append(np.concatenate((['#'], line, ['#'])))
    output.append(['#'] * (len(input[0]) + 2))
    return output

def find_trails(pos, last_value, trailtops):
    value = matrix[pos[0]][pos[1]]
    if value == '#':
        return
    elif value == str(int(last_value) + 1):
        if value == '9':
            trailtops.append((pos[0],pos[1]))
            return
        else:
            for r, c in directions:
                find_trails((pos[0]+r,pos[1]+c), value, trailtops)
    
input=[]
matrix=[]

with open(sys.argv[1], "r") as file:
    for line in file:
        line = list(map(int, line.strip()))
        if len(line) > 0: 
            input.append(line)
matrix = pad_input(input)

trailhead_scores = 0

for i in range(len(matrix)):
    for j in range(len(matrix[i])):
        if matrix[i][j] == '0':
            visited_heads = []
            find_trails((i,j), '-1', visited_heads)
            trailhead_scores += len(visited_heads)

print(trailhead_scores)