day := 7;
test_input := ["$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"];
test_ans := [[95437], [24933642]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

check_submit! 2, (\l ->(
    csize := {:0};
    pwd := [];
    # print l;

    for(line <- l.lines)
    (
        # print line;
        switch (line.words)
        case "$", "cd", "/" -> (pwd = [])
        case "$", "cd", ".." -> (pop pwd)
        case "$", "cd", x -> (pwd append= x)
        case "$", "ls", -> null
        case "dir", _ -> null
        case size, _name -> (
            for (p <- prefixes(pwd)) csize[p] += int(size);
        )
        print csize;
        print pwd;
    );
    # return csize.values filter (<= 100000) then sum;
    free_space := 70000000 - csize[[]];
    minimum_space_to_free := 30000000 - free_space;
    return csize.values filter (>= minimum_space_to_free) then min;
    # return 10;

))

