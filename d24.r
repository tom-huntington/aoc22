day := 24;
test_inputi := [
"#.#####
#.....#
#>....#
#.....#
#...v.#
#.....#
#####.#
"];
test_input := [
"#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
"];
test_ans := [[18], [54]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


check_submit! 2, \l, z -> (
    grid:= (l.lines);
    for(j,line<<-grid; i,ch<<- line)
        if (ch!="#") grid[j][i] = ".";
    height := grid[1:-1].len;
    width := grid[0][1:-1].len;
    print! width, height;
	winds:= for(j,line<<-(l.lines)[1:-1]; i,ch<<-line[1:-1]; if ch != ".") yield {V(i,j):[ch]} into (fold ||);
	# print! winds;
	# boarders:= for(j,line<<-l.lines; i,ch<<-line; if ch == "#") yield {V(i-1,j-1):ch} into (fold ||);
	# print! map;

	in_bounds := \pos-> ( if (pos==V(0,-1)) return true; if(pos==V(width-1, height))return true; return (0<=pos[0]<width) and (0<=pos[1]<height););
	positions := [V(0,-1)];
	visited_end:= false;
	visited_start:= false;
	for(cnt <- iota 1)
    (
        adjacencies := [V(0,0),V(1,0),V(-1,0),V(0,1),V(0,-1)];
        print cnt;
        direction := \ch->switch(ch) case ">"->V(1,0) case "<"->V(-1,0) case "v"->V(0,1) case "^"->V(0,-1) case []->null;
        winds_:= {:[]};
        # print "start winds";
    	for (pos,chars<<-winds; ch<-chars; pos_:= pos+ch.direction) winds_[V(pos_[0]%%width, pos_[1]%%height)] append= ch;
        # print "end winds";
    	winds=winds_;
    	# print F"winds.len: {winds.len}";
    	# print "start positions";
		positions = positions flat_map (\pos-> pos.five_adjacencies filter (\p-> p not_in winds and p.in_bounds and (winds[pos] all (!= (p-pos))))) then set;
		# print "end positions";
		# print! positions;
		# print! F"winds: {winds}";
		# print! "positions.len", positions.len;
		# print! "positions", positions;
		# grid3:=grid;
		# for ((i,j)<-positions) grid3[j+1][i+1]="*";
		# # print! grid2 join "\n";
		# # grid3:=grid;
		# for((i,j),chars<<-winds; ch<-chars) grid3[j+1][i+1]=ch;
		# print! grid3 join "\n";
		# sleep(1);
		# if (positions.len == 0) break;
		if (V(width-1, height) in positions) (if (not visited_end) (visited_end=true; positions=[V(width-1, height)]); if (visited_start) return cnt;);
		if (V(0,-1) in positions and visited_end and not visited_start) (positions=[V(0,-1)]; visited_start=true);
    );
)
