numbers = [int(x) for x in open('p20.in')]
indices = list(range(len(numbers)))

for i in indices * 1:
    indices.pop(j := indices.index(i))
    indices.insert((j+numbers[i]) % len(indices), i)

zero = indices.index(numbers.index(0))
print(sum(numbers[indices[(zero+p) % len(numbers)]] for p in [1000,2000,3000]))

