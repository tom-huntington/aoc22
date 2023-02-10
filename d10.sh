day := 10;
test_input := ["addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop"];

test_ans := [[13140], ["##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

n_cycles := {"noop": 1, "addx": 2};
print "hi";
fn := \l ->(
print "ih";
    cycle := 1;
    register := 1;
    signals := {};
    pixels := [];
        pri := \ ->(
        return;
        sprite := "." ** 40 join "";
        r := register % 40;
        sprite[r-1]="#"; sprite[r]="#"; prite[r+1]="#";
        print sprite;
        );
        pri();
    for (line <- l.lines)
    (
        add_ := \ -> (
        pixels append= switch({register-1:null, register:null, register+1:null} && {(cycle - 1)%40:null} then len)
        case 1 -> "#"
        case 0 -> "."
        ;
        if ((cycle - 20) % 40 == 0) signals[cycle] = cycle*register;
        # print F"during cycle {cycle} pos: {cycle -1}: Reg: {register}";
        # print! pixels group 40 then last then (_ join "");
        );
        add_();
        # print "==";
        switch(line[:4])
        case "addx" -> (cycle += 1; add_(); register += int(line[5:]); cycle += 1; pri())
        case "noop" -> (cycle += 1)
        ;

    );
    # print! signals;
    # return signals.values then sum;
    ret := pixels[0:40*6+1] group 40 map (join "") join "\n";
    # print! pixels.len;
    assert! pixels.len == 40*6;
    # ret := 0 til 40*6 group 40 map2 (_ % 10) map (join "") join "\n";
    # print ret;
    print ret;
    print "ihi";
);
fn(puzzle_input);
