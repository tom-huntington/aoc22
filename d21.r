day := 21;
test_input := ["root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"];
test_ans := [[152], [301]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

iota_ :=\a,b -> a to b by ((b-a)//abs(b-a));

check_submit! 2, \l, z -> (
    ast := l.strip.lines map (\line -> ({line[:4]:line[6:].split(" ")})) fold ||;

    subsititute := \name -> (
        	expr := ast[name];
        	# print! F"name: {name} expr: {expr}";
        	# if (try(int(expr); true) catch _ -> false) return expr;
			if (name == "humn") return "humn";
        	if (expr.len == 1) return expr[0];

			left, op, right := expr;
			if (name == "root") op = "-";
			print! "name", name;
			left = subsititute(left);
			right = subsititute(right);
			# print! "sasa", left, right;
        	return F"({left}){op}({right})";
        	

        );
	expr := subsititute("root");
    eval F"fn:= \\humn -> {expr};";

	a, b := [-1,1] map (*100000000000000);
	while(true)
    (
        c := (b + a) // 2;
        print(c);
        # sleep(1);
        if (fn(c)==0) return c;
        if (fn(c)*fn(a)<0) b = c else a = c;
    );




    # ast := l.strip.lines map (\line -> (name := line[:4]; value:=null; try(res +. int(line[6:])) catch _ -> (value= line[6:].split(" ")); {name:value})) fold ||;
    # # print! ast;

    # resolved := ast filter (_.len == 2);
    # unresolved := ast filter (_.len > 2);

    # fn := \resolved, unresolved -> (
    #     	next_unresolved = [];
    #         for (name, (left, op, right) <- unresolved)
    #         (
    #             if (left is str and left in resolved)
    #                 left = resolved[left];

                
                    
                    
    #         )


    #     );
    

)
