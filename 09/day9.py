import sys

with open(sys.argv[1], "r") as file:
    for line in file:
        if line != '\n':
            fileblocks = [int(x) for x in list(line.strip())]

pos = 0
checksum = 0

for id, blocksize in enumerate(fileblocks):
    if id % 2 == 0: # file-block
        for _ in range(blocksize):
            checksum += (pos * (id // 2))
            pos += 1
    else:
        for _ in range(blocksize):
            if fileblocks[-1] == 0:
                del fileblocks[-2:]
            checksum += (pos * ( (len(fileblocks)-1)//2 ))
            pos += 1
            fileblocks[-1] -= 1

print(checksum)