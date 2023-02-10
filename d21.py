from functools import reduce

parse = lambda line: {line[:4]: line[6:-1].split(" ")}
ast_nodes = reduce(lambda a, b: a | b, (parse(x) for x in open('p21.in')))

def sub(name):
    expr = ast_nodes[name]
    if (name == "humn"): return "humn"
    if (len(expr) == 1): return expr[0]
    left, op, right = expr
    if (name == "root"): op = "-"
    return f"({sub(left)}){op}({sub(right)})"

fn = eval(f"lambda humn: {sub('root')}")
a, b = [x*100000000000000 for x in [-1, 1]]
while(True):
    c = (b + a) // 2;
    if (fn(c) == 0): print(c); break
    if (fn(c) * fn(a) < 0): b = c
    else: a = c;
