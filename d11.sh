
day := 11;
test_input := ["Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"];

test_ans := [[10605], [2713310158]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

# struct Monkey(itms, op, pred, dest);

check_submit! 2, \l ->(
    monkeys := l split "\n\n"
        map (split "\n")
        map (\lines ->
        (
            print lines;
            [
                lines[1].nn_ints,
                eval F"\\old -> old {lines[2][23:]}",
                int(lines[3][21:]),
                [lines[5], lines[4]] map (search R"\d+") then (map int),
                0
            ]

        )
        )
    ;
    mod2 := monkeys map (!!2) then product;
    for (round <- 0 til 10000; i <- monkeys.keys)
    (
        # if (i == 0 and round % 100 == 0)
        #     print! monkeys map (!!0);
        
        print round;
        itms, op, mod, dest, _ := monkeys[i];
        for (item <- itms)
        (
            new := op(item) % mod2; # then (// 3);
            # print new;
            # print dest;
            monkeys[dest[new % mod == 0]][0] append= new;
            monkeys[i][-1] += 1;
            
        );
        monkeys[i][0] = [];
    );
    print! monkeys map last;
    sorted := monkeys map last then sort;
    return sorted[-2:] then product; # sorted[-1] * sorted[-2];


)
