day := 22;
test_input := [
"        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"];
test_ans := [[6032], []];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


check_submit! 1, \l, z -> (
    board, path := l split "\n\n";
    board = board.lines;

    path = path.strip map (\m->try(int(m)) catch _ -> m) group (\a,b-> a is int and b is int or a is str and b is str)
    flat_map (\g-> if(g[0] is str) g else null .* (g.reverse.enumerate map (\(i,el)-> (print! i,el;(10 ^ i)*el)) fold +))
    ;
    print! path;
    

	width := max! board map len;
	height := board.len;

	board map= (\line -> line $$ (" ".*(width-line.len) join ""));
	grid := board;

	rs:=[V(1,0), V(0,1), V(-1,0), V(0,-1)];
	rotate:=\v,d -> rs[(d+(rs locate v))%%rs.len];

	fmt_dir := \v-> (switch (v)
	                 case (1,0):-> ">"
	                 case (0,1):-> "v"
	                 case (-1,0):-> "<"
	                 case (0,-1):-> "^");
	
	mod :=\v-> V(v[0] %% width,v[1] %% height);
	dir := V(1,0);
	cur := V(board[0] locate ".", 0); 
    grid[cur[1]][cur[0]]=fmt_dir(dir);

	print! cur;
	for (m <- path; cur_:= cur)
    	(
        # print! F"dir {dir}";
    	switch(m)
    	case steps:null-> (cur=mod(cur+dir);) 
    	case "L": -> (dir=rotate(dir,-1))
    	case "R": -> (dir=rotate(dir,1));

		
    	 while(board[cur[1]][cur[0]] == " ") cur=mod(cur + dir);
    	 if(board[cur[1]][cur[0]] == "#") (cur=cur_);

        grid[cur[1]][cur[0]]=fmt_dir(dir);
        # print! grid join "\n"; print "--------------\n";
    	);

    print! F"cur: {cur} dir: {dir}";

    print! grid join "\n";

    print F"dir: {dir} cur: {cur}";

    facing := switch (dir) case (1,0): -> 0 case (0,1): -> 1 case (-1,0): -> 2 case (0,-1):->3;

	eval! F"1000 * {(cur[1]+1)} + 4 * {(cur[0]+1)} + {facing}"
	
)
