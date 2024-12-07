import sys

def recursive_compute(value, sum, numbers):
    if value == sum and not numbers:
        return True
    elif not numbers:
        return False
    else:
        add = recursive_compute(value, sum + numbers[0], numbers[1:])
        mul = recursive_compute(value, sum * numbers[0], numbers[1:])
        con = recursive_compute(value, int(str(sum) + str(numbers[0])), numbers[1:])
        return (add or mul or con)

calibration_result = 0

with open(sys.argv[1], "r") as file:
    for line in file:
        line = line.partition(":")
        if line[1]:
            value = int(line[0])
            numbers = [int(x) for x in line[2].split() if x.isdigit()]
            if recursive_compute(value, numbers[0], numbers[1:]):
                calibration_result+=value
print(calibration_result)