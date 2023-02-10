day := 14;
test_input := ["498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"];
# test_input := ["492,65 -> 492,64 -> 492,65 -> 494,65 -> 494,59 -> 494,65 -> 496,65 -> 496,64 -> 496,65 -> 498,65 -> 498,62 -> 498,65 -> 500,65 -> 500,63 -> 500,65 -> 502,65 -> 502,59 -> 502,65 -> 504,65 -> 504,64 -> 504,65 -> 506,65 -> 506,63 -> 506,65 -> 508,65 -> 508,63 -> 508,65"];
test_ans := [[24], [93]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

check_submit! 2, \l -> (
    vertices := l.lines map nn_ints map (group 2); # map2 vector;

    rocks2 := vertices map (window 2);

    between := \x0, x1 -> if (x0<x1) x0 to x1 else x1 to x0;
    rocks := rocks2 map (flat_map (\((x0, y0),(x1, y1)) -> if (x0==x1) (x0.repeat zip between(y0, y1)) else (print! between(x1, x0).list;between(x1, x0) zip y0.repeat)))
        flat_map id
        map vector
        # flat_map id
        then set
        ;

    bottom:=rocks map second then max;
    rocks ||= (set! 0 to 1000 zip repeat(bottom+2) map vector);

    width := 190;
    grid:="." .* width join "" then (.* (bottom + 3));
    # print! grid join "\n";
    # throw "";

    for ((x,y) <- rocks)
        (
        i := x-500+width//2;
        if(i>=0 and i<width) grid[y][i] = "#";
        );

    print! grid join "\n";
    # throw "";

    # print! bottom;
    sand := set(rocks);
    # last_sand := {};
    skip := [];
    for (i <- iota 1)
    (
        s := if (skip.len) (pop skip) else V(500, 0);
        update := \ -> (
            # print s;
            # if (s[1] == bottom) (throw 1;s=null; return false);
            # if () (s = null; return false);

            if (s + V(0, 1) not_in sand) (skip append= s; s+=V(0, 1); return true;);

            if (s + V(-1, 1) not_in sand) (skip append= s; s+=V(-1, 1); return true;);
            if (s + V(1, 1) not_in sand) (skip append= s; s+=V(1, 1); return true;);
            if (s == V(500, 0)) s = null;
            # skip = s + V(0, -1);
            return false;
            );

        while (update())
        (

            # grid2[s[1]][s[0] -500 + width//2] = "~";
            # print! grid2 join "\n";
            # print "";
            null
        );
        # if (skip is null then not) (print "skiping"; s = skip);
        # throw "";

        # if (1)
        if (i % 200 == 0)
        (
        # sleep(1);
        grid2 := grid;

        for ((x,y) <- sand)
        (
        i :=x -500+width//2;
        if(i>=0 and i<width) # grid[y][i] = "#";
            grid2[y][i] = "o";
        );
        for ((x,y) <- rocks)
        (
            i :=x -500+width//2;
            if(i>=0 and i<width)  grid2[y][i] = "#";

        );

        if (skip.len)(
        ii :=skip[-1][0]-500+width//2;
        if (i>= 0 and i < width) grid2[skip[-1][1]][ii] = "@";
        );
        print! grid2 join "\n";
        # print i;

        # print sand;
        );
        
        if (s is null)
        (
            # print "null";
            # write_file("vis.txt")(grid2);
            print! sand.len - rocks.len + 1;
            return i;
            # return sand.len + 1;
        );
        # print F"sand {sand}";

        # if (s + V(1,0) in and s + V(-1, 0) in sand)
        sand |.= s;


        # print! i, sand.len;

        if (s[1] > bottom + 2)
            throw "not reached";
        # if (s[1] == bottom)
        #     return i;
    )
)
