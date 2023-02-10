rocks, i = ((0,1,2,3),(1,0+1j,2+1j,1+2j),(0,1,2,2+1j,2+2j),(0,0+1j,0+2j,0+3j),(0,1,0+1j,1+1j)), 0
jets,  j = [ord(x)-61 for x in open('p17.in').read().strip()], 0
tower, cache, top, cycle_height, step = set(), dict(), 0, None, -1

empty = lambda pos: pos.real in range(7) and pos.imag>0 and pos not in tower
check = lambda pos, dir, rock: all(empty(pos+dir+r) for r in rock)

while (True):
    step += 1
    pos = complex(2, top+4)                     # set start pos
    if step == 2022: print(top)
    elif step == int(1e12) - 1: print(top+cycle_height); break

    key = i, j
    if key in cache and step > 1000 and cycle_height is None: # check for cycle
        S, T = cache[key]
        d, m = divmod(1e12-step, step-S)
        cycle_height = (top - T) * d
        step += (step - S) * d

    else: cache[key] = step, top

    rock = rocks[i]                             # get next rock
    i = (i+1) % len(rocks)                      # and inc index

    while True:
        jet = jets[j]                           # get next jet
        j = (j+1) % len(jets)                   # and inc index

        if check(pos, jet, rock): pos += jet    # maybe move side
        if check(pos, -1j, rock): pos += -1j    # maybe move down
        else: break                             # can't move down

    tower |= {pos+r for r in rock}              # add rock to tower
    top = max(top, pos.imag+[1,0,2,2,3][i])     # compute new top
