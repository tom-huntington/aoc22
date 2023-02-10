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
test_ans := [[1651], []];
# 25 26 28

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

# struct BestPath(visited, d, accum);

check_submit! 1, \l, b -> (
    valves := l.lines map (_ split ";" then (\(a,b)-> {a[6:8]: [int(a[23:]), b split ", " map (_[-2:])]})) fold ||;

    non_zero := valves filter (\k -> valves[k].first);
    # print non_zero;

    # perms := non_zero.permutations;
    
    lookup := non_zero.enumerate map (\(i,k) -> {k:i}) fold ||;
    # print! non_zero;
    # print! valves;
    # print! lookup;

    distance := \v0, v1, visited -> (
        if (v0 == v1) return 1;
        next := valves[v0].second filter (_ not_in visited);
        if (not next)
            return 10000;
        next map (\v -> distance(v, v1, visited |. v0)) then min then (+1)
    );

    # print! "distance AA DD:", distance("AA","DD",{});
    # return;

    matrix := non_zero map (\v0 -> non_zero map (\v1 -> distance(v0, v1, {})));
    print F"created matrix";

    dist_ := \a, b -> matrix[lookup[a]][lookup[b]];

    flow := \path -> path map (\v -> valves[v].first) fold + from 0;

pressure := \path -> (
        dist:= distance("AA", path[0], {});
        result := 0;
        # flow := \i -> path[:i] map (\v -> valves[v].first) fold + from 0;
        for (i <- 1 til path.len)
        (
            # print F"walking to and turning on: {path[i]}";
            next_dist := matrix[lookup[path[i-1]]][lookup[path[i]]];
            f := flow(path[:i]);
            if (dist + next_dist > 30)
                return result + (30-dist) * f;

            increment := f * next_dist;
            # print F"flow: {f}, steps: {next_dist}, total {increment}";
            result += increment;
            dist += next_dist;
        );
        return result + (30-dist) * flow(path);
        );

    best := ["DD", "BB", "JJ", "HH", "EE", "CC"];
    best1 := ["DD", "JJ", "HH", "BB", "EE", "CC"];

    acc_dist := \path ->(path window 2 map (\(a,b)-> a dist_ b) fold + from distance("AA", path[0],{}));

    # print F"best1 {best1} presure: {best1.pressure} acc_dist: {best1.acc_dist}";
    # print F"best {best} presure: {best.pressure} acc_dist: {best.acc_dist}";
    # return;

    paths := non_zero map (\v -> [[v], 0, distance("AA", v, {})]);
    # print paths;
    nodes := non_zero.set;

    # for(i <- best.keys)
    # (
    #     print F"{best[:i+1]} acc_dist: {best[:i+1].acc_dist}";
    # );
    # return;


    # map (\v -> valves[v].first) fold + from 0;
    

    for (i <- 1 til non_zero.len)
    (
        
        paths_by_node := non_zero map (\n -> paths
            filter (\path ->( b:=n not_in path[0]; if (path[0] == best[:i]) print(F"b: {b} path: {path[0]} n: {n} ");b))
            map (\path -> [path[0] +. n, path[0].flow * dist_(n, path[0][-1]) + path[1], path[2] + dist_(n, path[0][-1])])
            filter (\path ->(d:=path[0].acc_dist; b1 := d <= 30; b1))
        );
        # print paths_by_node;
        flat_paths_by_node := paths_by_node flat_map id;
        # print! flat_paths_by_node map first;

        # print i;
        for (p<- flat_paths_by_node)
        (
            if (p[0] == best[:i+1])
                print F"p: {p}";
        );
        # print i;
        print! i, best[:i+1];
        assert! best[:i+1] in (flat_paths_by_node then (map first));
        
        collapsed := paths_by_node map (\paths -> paths
            map (\path -> [path[0].sort, path[1], path[2]])
            sort (\path0, path1 -> path0[0] <=> path1[0])
            group (\path0, path1 ->path0[0].acc_dist == path1[0].acc_dist and path0[0] == path1[0])
            map (\grp -> (b:=best[:i+1] in (grp map first); res:=grp fold (\acc, el-> if (acc[1] < el[1]) el else acc); if(b) print F"grp: {grp}, res: {res}, acc_dist: {res[0].acc_dist}"; res))
            );
        # break;

        # print! collapsed;

        paths = collapsed flat_map id;

        # print! i, paths.len;
        print! i, best[:i+1];
        assert! best[:i+1] in (paths map first);

        # paths_by_node map
        
        # best_path_keys = (best_path_keys zip non_zero)  map (\(ks, n) -> ks fold (\k_acc, k ->
        # (
        #     v_acc, a_acc := best_paths[k_acc];
        #     v, a := best_paths[k];
        #     if (a + valves[k].first * dist_(n, k) < a_acc + valves[k_acc].first * dist_(n, k_acc)) k_acc else k
        # )));
        # print best_path_keys;
        # break;
    );

    
    # print! best.pressure;

    # print! F"paths {paths}";

    pressures :=  paths map (_.first.pressure);
    m := pressures then max;
    # i := pressures locate m;
    # print! paths[i].first;
    # print! best;
    m


)

