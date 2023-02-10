day := 15;
test_input := ["Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"];
test_ans := [[26], [56000011]];
# 25 26 28

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

check_submit! 2, \l, b -> (
    input := l.lines map (_ split ":" map (_.ints.vector));
    # print! input;
    # print input;

    # row_y := if (b) 2000000 else 10;
    most := if (b) 4000000 else 20;



    input map= (\(s,b) -> [s, (s-b).abs.sum]);
    # print "asas";
    perimiter := \(s, dist) -> (
        # print "in perimiter";
        dist += 1;
        conners := [V(-dist, 0), V(0, -dist), V(dist, 0), V(0, dist), V(-dist, 0)] window 2 map2 (+s);
        conners
        # print conners;
        # return conners flat_map (\((a0, a1),(b0, b1)) -> (
            # # print F"a: ({a0}, {a1}) b ({b0}, {b1})";
            # rngx:= a0 between b0;
            # rngy:=a1 between b1;
            # # print! rngx.list;
            # # print! rngy.list;
            # zip(rngx, rngy)
            # ))
            # then set
            # filter (\p -> p map (0 <= _<= most) fold &)
            # map vector
            # ;
    );
    
    # sig := [V(0,0), 2];
    # print "sasa";
    # a := perimiter_(sig);
    # print a;
    # print "after";
    # return;
    # throw "ex";
    # return;

        # 
    # grid := "." .* 21 join "" then (.* 21);

    intersection := \((a0, a1), (b0, b1)) ->
    (
        bcoeff := b1 - b0;
        acoeff := a1 - a0;

        if ((bcoeff fold /) == (acoeff fold /))
            return null;
        #  s * acoeff = b0-a0 + t * bcoeff
        s := [b0 - a0, acoeff] map (_ * bcoeff.reverse then (fold -)) fold /;
        # print! s, acoeff, acoeff * bcoeff.reverse;

        return (s * acoeff) map int then (_.vector + a0);
        
    );


    # print! intersection([V(0,0), V(2,2)], [V(0,2),V(2,0)]);
    # throw "end";


    intersections := input flat_map perimiter then (combinations 2) map intersection filter id filter (_ map (0<= _ <= most) fold &);
    for (intersec <- intersections)
    (
        b:= input fold (\accum, (sig, dist) -> (accum &)! not! (intersec - sig).abs.sum <= dist) from 1;
        if (b)
            return intersec[0] * 4000000 + intersec[1];
    );
    throw "not reached"
    print! intersections;

    
    cnt := 0;
    for (s <- input)
    (
        p := s.perimiter;
        assert! sp is list;
        print F"perimiter size: {sp.len}";
        # for (p <- sp)
        # (
        # if (p map (0 <= _<= most) fold &)
            # continue;
        #     grid[p[1]][p[0]] = "#";


        for (sig <- input)
        (
            null
        );

        # b:= input fold (\accum, (sig, dist) -> (accum &)! not! (p - sig).abs.sum <= dist) from 1;
        if (b)
        (
            # throw "b";
            # print! p;
            # if (p map (0 <= _<= most) fold &)
            # (
            return 4000000 * p[0] + p[1];
            # grid[p[1]][p[0]] = "@";
            # )
        );
        # );
        cnt += 1;
        print cnt;
    );
    # print! grid join "\n";




    throw "not reached";
    # print F"row_y {row_y}";
    # intersecting := input filter (\((s0,s1),(b0,b1)) -> (dist := abs(s0-b0) + abs(s1-b1); abs(row_y -s1) <= dist));

    # grid := "." .* 30 join "" then (.* 25);
    # grid[row_y + 2] = "#" .* 30 join "";
    # for ((i, ((s0,s1), (b0,b1))) <- intersecting.enumerate)
    # (
    #     grid[s1+2][s0+2] = chr(ord("A")+i);
    #     grid[b1+2][b0+2] = chr(ord("a")+i);
    # );
    # print! grid join "\n";

    single := [[V(8,7), V(2,10)]];

    # print sorted;


    for (y <- 0 to most)
    (
        no_beacon := input map (\(s, b) ->
            (
            dist := s-b then abs then sum;
            diff := s[1] - y then abs;
            if (diff < 0) throw "diff < 0";
            extra := dist - diff;
            if (extra < 0) return null;
            [s[0] - extra, s[0] + extra + 1]
            )
        ) filter (_ is null then not);
    sorted := no_beacon sort (\(a0,a1),(b0, b1)-> a0 <=> b0);
    print! y;
    # print! sorted;

    union := sorted[0];
    for (i <- sorted.keys)
    (
        if (i == 0) continue;
        a0, a1 := union;
        b0, b1 := sorted[i];
        if (a1 < b0)
        (
            # print! F"({a0}, {a1}), ({b0}, {b1})";
            # throw "not reached";
            assert! a1+1 == b0;
            union = V(a1, a1);
            break;
        );
        union = V(a0, a1 max b1);

        
    );
    # union := sorted fold (\(a0, a1), (b0, b1) ->(
    #     if (a1 < b0)
    #     (
    #         # print! F"({a0}, {a1}), ({b0}, {b1})";
    #         # throw "not reached";
    #         assert! a1+1 == b0;
    #         return V(a1, a1);
    #     );
    #     V(a0, a1 max b1)
    # ));

    
    if (union[0] == union[1])
    (
        print F"distress beacon: {union[0]}, {y}";

        return union[0] * 4000000+ y;
    );
        
    # print F"union: {union}";
    assert! union[0] <= 0 and union[1] > most;
    );

    throw "not reached";

    beacons := input map second filter (\(s0,s1) -> s1 == row_y) then set;

    # print! no_beacon;
    # line := "." .* 40 join "";
    # start:= 7;
    # for(b0 <- no_beacon)
    # (
    #     line[b0+start] = "#";
    # );
    # line[2+start] = "B";
    # print! line;
    # # count no_beacon
    # print no_beacon;
    # print! no_beacon.len;
    # print! no_beacon.count;
    # print! no_beacon.enumerate;
    # print! no_beacon;

    print beacons;
    print! beacons.len, no_beacon.len;
    union[1] - union[0] - beacons.len
)
