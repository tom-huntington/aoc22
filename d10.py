from itertools import accumulate
flat_map = lambda f, xs: [y for ys in xs for y in f(ys)]

f = lambda line: [0] if line == "noop" else [int(line[5:]), 0]
xs = flat_map(f, open('p10.in').read().strip().split("\n"))

part1, part2 = 0, '\n'
for i, x in enumerate(accumulate([1]+xs), 1):
    part1 += i*x if i%40==20 else 0
    part2 += '#' if (i-1)%40-x in [-1,0,1] else ' '

print(part1, "\n"+"-"*40, *part2)

