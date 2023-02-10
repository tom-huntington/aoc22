from itertools import accumulate, zip_longest

parse = lambda x: -2 if x == "=" else (-1 if x == "-" else int(x))
snafus = [[parse(ch) for ch in reversed(line)] for line in open('p25.in').read().split()]
snafu = list(map(sum, (zip_longest(*snafus, fillvalue=0))))

divisors = accumulate([0]+snafu, lambda acc, el: (acc+el+2)//5)
snafu = map(lambda a,b: ((a+b+2)%5)-2, snafu, divisors)

unparse = lambda x: "=" if x == -2 else ("-" if x == -1 else str(x))
print("".join(reversed(list(map(unparse,snafu)))))
