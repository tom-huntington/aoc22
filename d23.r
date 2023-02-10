day := 23;
test_input := [
"....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"];
test_ans := [[110], [20]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


check_submit! 1, \l, z -> (
	elves:= l.strip.lines.enumerate flat_map (\(j, line)-> line.enumerate map (\(i,ch)-> if (ch == "#") {V(i,j):null} else null)) filter id fold ||;
	directions := [
		[V(-1,-1), V( 0,-1), V( 1,-1)], # north
		[V(-1, 1), V( 0, 1), V( 1, 1)], # south
		[V(-1,-1), V(-1, 0), V(-1, 1)], # west
		[V( 1,-1), V( 1, 0), V( 1, 1)]  # east
	];
	print! "hi";
	i:=0;
	print_elves:=\s-> (
    	return;
        grid := "." .* 14 join "" then (.* 12);
        for ((x,y) <- elves)
            grid[2+y][3+x] = "#";
        print! grid join "\n";

    	);
	print_elves(elves);
	for (i <- iota 0)
    (
        dirs := for (j <- i til (i+4)) yield directions[j%%4];
        # print! i, dirs;
        elves_ := {};
    	proposed := {:0};
        # print! i;#, dirs;
        for (elf <- elves)
            for (adjacent_ <- dirs map (map (+elf)))
            (
                # if (elf[1] < 1) print! F"elf {elf} {eight_adjacencies(elf).set && elves}";
                if (eight_adjacencies(elf) all (not_in elves)) break; # (print F"elf: {elf} move {adjacent_[1]}";break;);
                if (adjacent_ all (not_in elves)) (elves[elf] = adjacent_[1]; proposed[adjacent_[1]]+=1; break;);
            );

		moved:= false;
        for (elf, prop <<- elves)
            if (proposed[prop]==1) (elves_ |.= prop; moved=true;) else elves_ |.= elf;

        # i+=1;
        elves = elves_;
        # print_elves(elves)
        # print! elves;
        if (i==9) break;

        # if (i%%100 == 0) print i;

		print! i, moved;
        if (not moved) return i+1;
    );

	xmin, xmax, ymin, ymax := [first, second] ** [min, max] map (\(proj, reduce_)-> reduce_! elves map proj);
	print! xmax-xmin, ymax-ymin;
	(xmax + 1 - xmin) * (ymax + 1 - ymin) - elves.len
	# 
);

# "
# ......#.....
# ..........#.
# .#.#..#.....
# .....#......
# ..#.....#..#
# #......##...
# ....##......
# .#........#.
# ...#.#..#...
# ............
# ...#..#..#..
# ";
