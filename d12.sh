day := 12;
test_input := ["Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"];
test_ans := [[31], [29]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

check_submit! 2, \l -> (
    lns := l.lines;

    locate_ := \ch -> (
        locations := lns map (locate? ch);
        print locations;
        j := locations locate (is int);
        V(locations[j], j)
    );

    E := locate_ "E";
    S := locate_ "S";
    print! E, S;
    lns[S[1]][S[0]] = "a";
    lns[E[1]][E[0]] = "z";




    elevations := lns map2 ord;
    N_i := lns[0].len;
    N_j := lns.len;

    as := til(0, N_i) ** til(0, N_j) filter (\(i,j)-> lns[j][i] == "a") map vector then set;

    in_bounds := \x, n -> x >= 0 and x < n;
    neighbours := \v -> [V(0, 1), V(0, -1), V(1,0), V(-1,0)]
        map (+ v)
        filter (\w -> in_bounds(w[0], N_i) and in_bounds(w[1], N_j))
        ;

    el := \v -> elevations[v[1]][v[0]];

    # vs := [V(0,0)];
    vs := {E:null};
    visited := set(vs);
    for (d <- iota 1)
    (
        # print! d, vs.len, visited.len;
        # print vs;
        vs = vs flat_map (\v -> v.neighbours
                filter (\w -> (b:= v.el - w.el then (<= 1); b)))
            filter (\w -> w in visited then not)
            then set
            ;

        # visited ||= set(vs);
        visited ||= vs;


        if (vs && as)
            return d;
        # if (E in vs)
        #     return d;

        # map := lns;
        # map[E[1]][E[0]] = "#";
        # for (v <- visited)
        # (
        #     map[v[1]][v[0]] = ".";
        # );
        # # print "";
        # print! (map join "\n") $$ "\n";

        # sleep! 0.1;


        # if (d == 50) break;
        
    );
    assert(0);


)
