import sys
from secrets import randbelow

rules = {} # A|B -> rules[A]=[B] -> B is a successor of A
updates = []

with open(sys.argv[1], "r") as file:
    for line in file:
        if '|' in line:
            x, y = map(int, line.split('|'))
            if x not in rules:
                rules[x]=[]
            rules[x].append(y)
        elif line.strip():
            updates.append([int(i) for i in line.split(',')])

def valid(update):
    # return true & value of middle element if valid, otherwise false & position of wrongly placed page
    for id, page in enumerate(reversed(update)):
        if page in rules:
            for other_page in update[:(len(update)-id)]:
                if other_page in rules[page]:
                    return False, (len(update)-id-1)
    return True, (update[len(update)//2])

sum = 0

for update in updates:
    result, value = valid(update)
    if result:
        continue
    # while not result:
    #     for i in range(value, len(update)):
    #         for j in range(i+1, len(update)):
    #             if update[i] in rules[update[j]]:
    #                 update[j], update[i] = update[i], update[j]
    #     result, value = valid(update)
    # sum+=value

print(sum)


# sort pages
while not is_ordered(pages):
  for i in range(len(pages)):
    for j in range(i+1, len(pages)):
      if update[j] in rules[i]:
        update[j], update[i] = update[i], update[j]