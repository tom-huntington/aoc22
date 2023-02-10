day := 25;
test_input := [
"1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
"];
test_ans := [["2=-1=0"], []];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


check_submit! 1, \l, z -> (
	coeffs_rng := l.lines map2 (\ch -> switch(ch) case "=" -> -2 case "-" -> -1 case _->int(ch)) map reverse;

	to_decimal:=\coeffs-> iota(0) zip coeffs with (\a,b-> b*5^a) then sum;
	coeffs := ziplongest(...coeffs_rng) map sum; 
	print! coeffs;
	print! coeffs.to_decimal;

	remainders := coeffs scan (\accum, el-> (accum+el+2)//5) from 0;

	# print! remainders;
	modded:= coeffs ziplongest remainders with (\a,b->((a+b+2)%%5)-2);
	print! modded.to_decimal;
	print! modded;

	modded[:-1].reverse map (\ch->switch(ch) case -2->"=" case -1->"-" case _->str(ch)) join ""

	# print! (iota 1) zip exponents;
)
