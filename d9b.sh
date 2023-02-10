day := 9;
test_input := ["R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"];
# test_input := ["R 5
# U 8
# L 8
# D 3
# R 17
# D 10
# L 25
# U 20"];
test_ans := [[13], [36]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

directions := {
	"U": V(-1,0),
	"R": V(0,1),
	"D": V(1,0),
	"L": V(0,-1),
};
snap := \v -> if (max(abs(v)) > 1) v - signum(v) else v;




check_submit! 1, \l ->(
    # knots := V(0, 0) .* 2;
    start := V(0, 0);
    seen := [start];

    steps := l.lines
        flat_map \line -> directions[line[0]] .* int(line[2:])
        ;


    seen ++= scan_(steps, (start .* 2), (\knots, step -> (
        # defer seen |.= last knots;
        # knots.adjacent map \(knot, pre) -> if (pre is null) knot + step else pre + snap(knot - pre)

        knots = knots.adjacent
            map \(knot, pre) -> if (pre is null) knot + step else pre + snap(knot - pre)
            ;
        # seen |.= last knots;
        [knots, last knots]

    )));

    # print seen;
    # print! seen.set;

    # rng2 := ("." .* 10 join "") .* 10; # join "\n";
    # for (el <- seen.set)
    # (
    #     print el;
    #     rng2[el[1]][el[0]] = "#";
    # );
    # print! rng2 join "\n";

    return seen.set.len;
)

