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

check_submit! 1, \l ->
(
    start := V(0, 0);
    visited := [{start}]**10;
    knots := [start]**10;
    DIR := {"U": V(0, -1), "L":V(-1,0), "D":V(0,1), "R":V(1,0)};
    
    for (line <- l.lines)
    (
        dir, steps := line split " ";
        for (step <- 0 til int(steps)) (
            knots[0] += DIR[dir];
            # x, y := knots[0];
            # assert (x >= 0);
            # assert (y >= 0);
            for (i <- 1 til knots.len) (
                abs_diff := (knots[i-1] - knots[i]); # map abs;
                if (abs_diff map (_.abs > 1) fold |)
                (
                    adjust := (knots[i-1]-knots[i]) map (_ min 1 then (_ max (-1))) then vector;
                    # print adjust;
                    knots[i] += adjust;
                    visited[i][knots[i]] = null;
                    # if (i== knots.len - 1)
                    #     matrix[knots[i][1]][knots[i][0]] = 1;
                );
            );
            # old_knots = knots;
        );
        # matrix2 := matrix map2 (\el -> (if (el==1) return "*" else return ".";));
        # for (i <- 0 til knots.len) matrix2[knots[i][1]][knots[i][0]] = i;
        # print! matrix2 map (join "") join "\n";
        # print "";
    );
    print "finishing";
    print visited;
    print! visited map len;
    return visited[0].len
    )

