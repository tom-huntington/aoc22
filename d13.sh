day := 13;
test_input := ["[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"];
test_ans := [[13], [140]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


short_fold := \rng->
(
    for (el <- rng)
        if (el != 0) return el;
);


check_submit! 2, \l -> (
    # lists := l split "\n\n" map lines map2 eval;

    packets := l.lines filter id map eval;
    print F"packets {packets}";


    
    # print lists;
    pred := \pair ->
    (
        print F"pair: {pair}";
        # print! left, right;
        # switch([left, right])
        res := switch(pair)
            case left : int, right: int -> left <=> right
            case left : int, right: list -> pred([[left], right])
            case left : list, right: int -> pred([left, [right]])
            case left : list, right:list -> (

            print "zip"; zl := zip(left, right); print! F"zl: {zl}"; preds := zl map pred; print F"preds: {preds} pair: {pair}";  fld:=preds.short_fold;
            print F"fld {fld}";
            # if (fld)
            #     return left.len <= right.len;

            # if (fld is null)
            # (
                b:= left.len <=> right.len;
                if (fld is null)
                    print F"b: {b}";
                # b

            # )
            if (fld is null) b else fld
            )
            ;
        print F"res {res}";
        res

    );
    
    # result:= packets zip (iota 1)
    #     filter (\(pair, i) -> (#(print F"-- {i} {pair}";) pred(pair) <= 0))
    #     map last
    #     ;

    unsorted := [[[2]], [[6]]]  ++ packets;
    sorted := unsorted.enumerate sort (\(_, packet0), (_, packet1) -> pred([packet0, packet1]));
    # print F"sorted {sorted}";
    for (el <- sorted map second then enumerate)
        print! el;
    result := [0, 1] map ((sorted map first) locate) map (+1) then product;
    print result;
    result
    

    
    


    
    # print "%%%%%%%%%%%%%%%%%%";
        # map last
        # then sum
   # print F"reslut: {result}";
   # return result.sum;
)

