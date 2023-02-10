def f(n, x=input()):
    return next(i+n for i in range(len(x))
        if len(set(x[i:i+n]))==n)

print(*map(f, (4, 14)))

