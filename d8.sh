day := 8;
test_input := ["30373
25512
65332
33549
35390"];
test_ans := [[21], [8]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

# scan1 := \rng, fn ->(
#     result := [];
#     accum := rng[0];
#     result append= 1;
#     for (el <- rng.tail)
#     (
#         accum_, b: = fn(accum, el);
#         accum = accum_;
#         result append= b;
#     );
#     return result;
# );

# check_submit! 1, (\l ->(
#     lines_ := l.lines;
    
#     ints_ := lines_ map (_ map int);
#     fn := _ scan1 (\acc, el -> ([acc max el, acc < el]));
#     left := ints_ map fn;
#     right := ints_ map (\x -> x.reverse.fn.reverse);
#     updown := ints_.transpose;
#     down := updown map fn then transpose;
#     up := updown map (_.reverse.fn.reverse) then transpose;

#     return zip(right.flatten, left.flatten, down.flatten, up.flatten) map (_ fold |) then sum;
# ));





check_submit! 2, \l->(
    grid := l.lines map (map int);
    rays := \i, j -> [V(0, 1), V(0, -1), V(1, 0), V(-1, 0)] map \delta ->
    	V(i, j) iterate (+delta) drop 1
    	# there's redundancy here but we can't map first because `map` is eager...
    	take (\[i', j'] -> grid !? i' !? j' != null)
    	map (\[i', j'] -> grid[i'][j']);

    ans:= for (i, row <<- grid; j, here <<- row) yield
    (
        rays(i, j) map \ray -> (
            seen := 0;
            for (h<-ray) (seen+=1; if (h>= here) break);
            return seen;
        )
    ) then product;
        # rays(i, j) any (_ all (< here))
        # ;
    print ans;
    
    ans.max
    
)
