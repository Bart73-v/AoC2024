import sys

with open(sys.argv[1], "r") as file:
    for line in file:
        if line != '\n':
            fileblocks = [int(x) for x in list(line.strip())]

checksum = 0
pos=0
disk=[]
files=[]
free_spaces=[]

for id, blocksize in enumerate(fileblocks):
    if id % 2 == 0: # file-block
        files.append((pos, blocksize, (id // 2)))
        for _ in range(blocksize):
            disk.append(id // 2)
            pos+=1
    else:
        free_spaces.append((pos, blocksize))
        for _ in range(blocksize):
            disk.append('.')
            pos+=1

for file in reversed(files): # file = (index, size, value)
    for id, free_space in enumerate(free_spaces):
        if file[1] <= free_space[1] and free_space[0] < file[0]:
            j=0
            for i in range(file[0]+file[1]-1, file[0]-1, -1):
                disk[i]='.'
                disk[free_space[0]+j]=file[2]
                j+=1
            free_spaces[id] = (free_space[0]+file[1],free_space[1]-file[1])
            break

for id, value in enumerate(disk):
    if value != '.':
        checksum += id*value
print(checksum)