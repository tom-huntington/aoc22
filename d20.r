day := 20;
test_input := ["1
2
-3
3
-2
0
4
"];
test_ans := [[3], [1623178306]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

iota_ :=\a,b -> a to b by ((b-a)//abs(b-a));

check_submit! 2, \l, b -> (
    numbers := l.strip.ints map (*811589153);
    modulus := numbers.len;

    indices := vector! 0 til numbers.len;
    for (j <- 0 til 10)
    for (i, n <<- numbers)
    (
        src := indices locate i;
        if (n == 0) continue;
        print! j, float(i) / modulus;
		dest := (n+src) % (modulus-1);

        for (j0,j1 <- src iota_ dest map (%% modulus) window 2)
			swap indices[j0], indices[j1];
            # print! indices map (numbers !!);

    );
    # ans := 1 to 3 map (\i-> indices !! (i*1000 %% numbers.len)) map (numbers !!);

	numbers = indices map (numbers !!);
	start := numbers locate 0;
    ans:= 1 to 3 map (\i -> numbers[(i*1000+start) %% modulus]);
    print ans;
    sum! ans
);
