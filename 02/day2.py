def strictly_increasing(reports):
    for i in range(len(reports)-1):
        if ( not reports[i] < reports[i+1] ) or ( (reports[i+1] - reports[i]) > 3):
            return False
    return True

def strictly_decreasing(reports):
    for i in range(len(reports)-1):
        if ( not reports[i] > reports[i+1] ) or ( (reports[i] - reports[i+1]) > 3):
            return False
    return True
        


safe_reports = 0

with open("../test-data/input-02.txt", "r") as file:
    for line in file:
        reports = [int(i) for i in line.split()]
        safe = False
        print(reports)
        if strictly_increasing(reports) or strictly_decreasing(reports):
            safe_reports+=1
        else:
            for i in range(len(reports)):
                if strictly_increasing(reports[:i] + reports[i+1:]) or strictly_decreasing(reports[:i] + reports[i+1:]):
                    safe = True
            if safe:
                safe_reports+=1

print(safe_reports-1)