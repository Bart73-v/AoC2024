import sys

matrix=[]

def check_in_bounds(i, j):
    # return False if out of bounds
    return not (i >= len(matrix) or j >= len(matrix) or i < 0 or j < 0)

def check_right(i, j):
    if check_in_bounds(i+2, j+2):
        return (matrix[i][j+2] == "S" and matrix[i+1][j+1] == "A" and matrix[i+2][j] == "M" and matrix[i+2][j+2] == "S")
    else:
        return False

def check_left(i, j):
    if check_in_bounds(i+2, j-2):
        return (matrix[i][j-2] == "S" and matrix[i+1][j-1] == "A" and matrix[i+2][j] == "M" and matrix[i+2][j-2] == "S")
    else:
        return False

def check_up(i, j):
    if check_in_bounds(i-2, j+2):
        return (matrix[i-2][j] == "S" and matrix[i-1][j+1] == "A" and matrix[i][j+2] == "M" and matrix[i-2][j+2] == "S")
    else:
        return False

def check_down(i, j):
    if check_in_bounds(i+2, j+2):
        return (matrix[i+2][j] == "S" and matrix[i+1][j+1] == "A" and matrix[i][j+2] == "M" and matrix[i+2][j+2] == "S")
    else:
        return False

with open(sys.argv[1], "r") as file:
    for line in file:
        row=[]
        for char in line:
            if char != '\n':
                row.append(char)
        if row:
            matrix.append(row)

xmas=0

for i in range(len(matrix)):
    for j, elem in enumerate(matrix[i]):
        if elem == "M":
            if check_right(i, j):
                xmas+=1
            if check_down(i, j):
                xmas+=1
            if check_left(i, j):
                xmas+=1
            if check_up(i, j):
                xmas+=1
print(xmas)