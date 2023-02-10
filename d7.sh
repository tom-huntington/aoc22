day := 7;
test_input := ["- / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)"];
test_ans := [[95437], []];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

remove_ := \s -> replace(s, "\n  ", "\n");

fn := \raw -> (
    first_line := raw search ".*\n?";
    if (first_line search "dir")
    (
        return raw[first_line.len -1:]
            .remove_
            .strip
            split "\n-"
            map fn
            then list
            ;
    );
    if (first_line search "file")
    (
        return first_line search R"\d+" then int;
    )
    throw "Not reached";
);

visit := \x ->(
    if (x is int) (print F"x is int x: {x}"; return [x, []]);
    if (x is list)
    (
        mapped := x map visit;
        ret := mapped fold (\el, b->(
            t, f := b;
            total, flat := el;
            return [total+t, flat++f];
            )
            ) from [0, []];
        tt, ff := ret;
        return [tt, ff ++ [tt]];
    )
    throw F"Not reached\n {x}";
);

check_submit! 1, (\l ->(
    print "START";
    dirs := (l
    .fn
    .visit
    );
    dirs2 := dirs.second;
    print dirs2;
     dirs3 := dirs2 filter (_ <= 100000);
     print dirs3;
     a := dirs3.sum;
     print a;
     return a;
    ))
    ;

