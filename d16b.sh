day := 16;
test_input := ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II"];
test_ans := [[1651], [1707]];
# 25 26 28

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


check_submit! 2, \l, b -> (
    valves := l.lines map (_ split ";" then (\(a,b)-> {a[6:8]: [int(a[23:]), b split ", " map (_[-2:])]})) fold ||;

    nodes := valves filter (\k -> valves[k].first or k == "AA") then set;
    lookup := nodes.enumerate map (\(i,k) -> {k:i}) fold ||;
    distance := \v0, v1, visited -> (
        if (v0 == v1) return 1;
        next := valves[v0].second filter (_ not_in visited);
        if (not next)
            return 10000;
        next map (\v -> distance(v, v1, visited |. v0)) then min then (+1)
    );
    matrix := nodes map (\v0 -> nodes map (\v1 -> distance(v0, v1, {})));
    dist_ := \a, b -> matrix[lookup[a]][lookup[b]];

    dfs := memoize \cur :str, rest:dict, t :int, b:int ->
    (
        max! (
            for(k <- rest; if dist_(cur, k) < t) yield
                (t-dist_(cur,k)) * valves[k].first + dfs(k, rest-. k, t- dist_(cur,k), b)
            ) +. (if (b) dfs("AA", rest, 26, 0) else 0)
    );

    # return dfs("AA", nodes -. "AA", 30, 0);
    return dfs("AA", nodes -. "AA", 26, 1);
)
