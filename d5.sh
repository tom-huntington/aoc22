day := 5;
test_input := ["    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"];
test_ans := [["CMZ"],"MCD"];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


# fn := \l, b -> l + b;

# print! fn(1,2)

check_submit! 2, (\l->(
    initial_state, moves := l split '\n\n';
    transposed := (initial_state.lines)[:-1]
        map list
        map (_ group 4 map second)
        # then print
        ;
    
    state := zip(...transposed)
        map reverse
        map (_ filter (!= " "))
        # then print
        ;
    print state;

    moves = moves.lines
        map ints
        # then print
        ;

    final_state := moves fold (\s, m ->(
        print m;
        count, src, dest := m;
        # for (_ <- 1 to count)
        #     s[dest - 1] append= pop s[src - 1];
        s[dest-1] ++= s[src-1][-count:];
        s[src-1] = s[src-1][:-count];

        print s;
        return s;)
    )
    from state;

    final_state map last join ""

    # initial_state
    # transposed
    
));
