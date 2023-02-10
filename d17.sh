day := 17;
test_input := [">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"];
test_ans := [[3068], [1514285714288]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


rocks := [
    [
        V(0,0),V(1,0),V(2,0),V(3,0)],
    [
                V(1,2),
        V(0, 1),V(1,1),V(2,1),
                V(1,0)
    ],
    [V(0,0),V(1,0),V(2,0),V(2,1),V(2,2)],
    [V(0,0),V(0,1),V(0,2),V(0,3)],
    [V(0,0),V(1,0),V(0,1),V(1,1)],
        ];

check_submit! 2, \l, b -> (
    bottom := 0 til 7 zip repeat(0) map vector;
    fall := V(0,-1);
    tower := set(bottom);
    
    heights := read_file("heights.txt").lines map int;
    
    jets := l.strip.list map (\c-> switch(c) case "<" -> V(-1, 0) case ">" -> V(1, 0));
    j := 0;
    top := 0;
    top2 := [];
    cache := {};
    i := -1;
    step := -1;
    N :=1000000000000;
    while (step < N-1)
    # for (i <- 0 til )
    (
        step += 1;
        i+=1;
        # print! i > 1000, i, step, "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";

        bcache :=i> 1000;
        # bcache := true;
        if (bcache)
        (
        m_i := i % rocks.len;
        m_j := j % jets.len;
        key :=V(m_i, m_j) ;
        # print F"key {key} <-------------------";
        if (key in cache)
        (
            print F"step {step}, key {key} jets.len {jets.len}";
            # if (step > 3291) return;
            S, T := cache[key];
            d := (N - step) // (i-S);
            m := (N - step) % (i - S);
            print F"m: {m}, S: {S}, T: {T}";
            # print! F"key: {key}, cache {cache}";
            # print! F"S: {S}, i -S: {i-S}";
            # print! F"d: {d} N-d-step: {N - step - d}, m: {m}";
            # return;
            if (d > 0 and step + d < N-1)(
            assert! step + d < N-1;
            top2 append= (top -T)*d;
            # top += (top -T)*d;
            step+= (i - S) *d;
            print top2;
            assert! top2.len == 1;
            );
            # if (m==0) return top + (top -T ) * d;
            
        )
        else cache[V(m_i,m_j)] = V(i, top);
       );
        # print! float(i)/1000000000000;
        pos := V(2, top+4);

        collides := \rock, shift, pos_ ->(
            rock2 := rock map (_ + shift + pos_);
            inter := set(rock2) && tower;
            # print! "shift", shift;
            # print! "pos", pos;
            # print! "rock", rock;
            # print! "inter", inter;
            # print! "rock2", rock2;
            # print! "tower", tower;
            b:=inter.len;
            bools := rock2 map (\r ->r.first< 0 or 7<=r.first);
            # print F"rock2: {rocks2}";
            # print F"bools: {bools}";
            b1 := (bools fold |);

            # print F"b: {b}, b1: {b1}, pos_+shift {pos_+shift}";
            b or b1

        );
        rock := rocks[i%rocks.len];

        draw := \pos__, top, shift ->(
            if (shift != V(0,0)) return;
            grid:="." .* 7 join "" then (.* (top+10));
            for (s <- tower) (grid[s[1]][s[0]] = "#");
            # print F"draw pos__ {pos__}, top: {top}";
            if (shift.first < 0) print "<<<<<<<<<";
            if (shift.first > 0) print ">>>>>>>>>";
            if (shift.second < 0) print "vvvvvvvv";
            # if (which
            for (r <- rock map (+pos__))( grid[r[1]][r[0]] = "@");
            grid = grid.reverse;
            print! grid join "|\n|";
            print "";
        );
        draw = \a,b,c-> null;

        draw! pos, top, V(0,0);
        while (true)
        (

            # if (bcache)
                # print! j % jets.len;
            
            jet := jets[j % jets.len]; j+=1;
            # print F"j: {j}";
            # print F"pos: {pos}";
            if (not! collides! rock, jet, pos) (pos = jet + pos;); # print F"+ jet, pos: {pos}";);
            # print F"pos: {pos}";
            draw! pos, top, jet;
            if (not! collides! rock, fall, pos) (pos = fall + pos;) # print F"+ fall, pos: {pos}"; draw! pos, top, fall; )
            else (#(draw! pos, top, V(0,0);) break);


            # print! rock map (_ + pos);
            # print! tower;
            # print! F"%%%%%%%%%%%%%%%%% {pos}";


        );
        top = rock map (_ + pos then second) +. top then max;
        tower ||= rock map (+ pos) then set;
        # print F"top {top}";
        # print! (tower map second then max), top, heights[i], i, heights.len;
        # assert! heights[i] == top;
        # if (i > 2 * rocks.len) break;
        # print "------------------------------";

        # print top;
        
    );
    top .+ top2 then sum
    # tower map second then max
)
