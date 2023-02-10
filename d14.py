import time

range_sorted = lambda *p: range(min(p), max(p)+1)
blocked = set()

for ps in [[*map(eval, line.split('->'))] for line in open('p14b.in')]:
    for (x1, y1), (x2, y2) in zip(ps, ps[1:]):
        blocked |= {complex(x, y) for x in range_sorted(x1, x2)
                                  for y in range_sorted(y1, y2)}

floor = max(p.imag for p in blocked)
part1, rock = 0, len(blocked)

height = int(max(map(lambda x: x.imag, blocked)))
print(height)

width = 150
grid = [list("." * width) for _ in range(height+1)]
for c in blocked:
    # print(len(grid), len(grid[0]), c.imag, c.real -500 +width//2)
    grid[int(c.imag)][int(c.real) -500 + width//2] = "#"
    # print("".join(grid[int(c.imag)]))
print("\n".join(map(lambda line: "".join(line), grid)))
    # time.sleep(0.1)

exit(0)

while 500 not in blocked: 
    pos = 500
    while True:
        if pos.imag > floor:
            if not part1: part1 = len(blocked)
            break
        for dest in pos+1j, pos-1+1j, pos+1+1j:
            if dest not in blocked:
                pos = dest
                break
        else: break
    blocked.add(pos)

print(part1-rock, len(blocked)-rock)

