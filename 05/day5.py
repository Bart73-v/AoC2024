import sys

rules = {} # A|B -> rules[A]=[B] -> B is a successor of A
pre_rules = {} # A|B -> rules[B]=[A] -> A is a predecessor of B
updates = []

with open(sys.argv[1], "r") as file:
    for line in file:
        if '|' in line:
            x, y = map(int, line.split('|'))
            if x not in rules:
                rules[x]=[]
            if y not in pre_rules:
                pre_rules[y]=[]
            rules[x].append(y)
            pre_rules[y].append(x)
        elif line.strip():
            updates.append([int(i) for i in line.split(',')])

def valid(update):
    for id, page in enumerate(reversed(update)):
        if page in rules:
            for other_page in update[:(len(update)-id)]:
                if other_page in rules[page]:
                    return False
    return True

sum = 0

def create_valid_update(elem, new_update, update, predecessors):
    update_copy=update.copy()
    update_copy.remove(elem)
    new_update_copy=new_update.copy()
    new_update_copy.append(elem)
    predecessors_copy=predecessors.copy()

    predecessors = []
    if not update_copy:
        #print("Found valid: " + str(new_update_copy) + " : " + str(new_update_copy[len(new_update_copy)//2]))
        return new_update_copy[len(new_update_copy)//2]
    elif elem in pre_rules:
        predecessors = list(set(update_copy) & set(pre_rules[elem]))
        if not predecessors:
            return 0
    #print("Elem: " + str(elem) + " Predecessors: " + str(predecessors))
        
    result = 0
    for predecessor in predecessors:
        result = max(result, create_valid_update(predecessor, new_update_copy, update_copy, predecessors_copy))
    return result

# print(rules)
# print(pre_rules)
# print(updates)


for update in updates:
    if valid(update):
        continue
    # print("Update: " + str(update))
    result = 0
    for page in update:
        if page not in pre_rules:
            predecessors = update.copy()
            predecessors.remove(page)
        else:
            predecessors = pre_rules[page]
        result = max(result, create_valid_update(page, [], update, predecessors))
    sum += result
    # print("Sum: " + str(sum))

print(sum)