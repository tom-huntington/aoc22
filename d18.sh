day := 18;
test_input := ["2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
"];
test_ans := [[64], [58]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();

check_submit! 2, \l, b -> (
    cubes := l.strip.lines map (_.nn_ints.vector);

    faces_connected := [V(0,0,1),V(0,1,0),V(1,0,0)] map (\e->set(cubes map (+e)) && set(cubes) then len) then sum;


    
    todo := [V(0,0,0)]; #,V(-1,20), V(20,20), V(20,-1)];
    seen := set(cubes);
    while(todo)
    (
        here := pop todo;
        if (here not_in seen and here all (0<= _ < 20))
        (
            seen |.= here;
            todo ++= [V(1,0,0),V(0,1,0),V(0,0,1),V(-1,0,0),V(0,-1,0),V(0,0,-1)] map (+ here);
        );
    );

    holes := list! set((0 til 20) ^^ 3 map vector) -- set(seen filter (_ map (0<=_<20) fold &));
    cubes ++= holes;
    faces_connected2 := [V(0,0,1),V(0,1,0),V(1,0,0)] map (\e->set(cubes map (+e)) && set(cubes) then len) then sum;
    
    cubes.len * 6 - faces_connected2 * 2


)
