day := 19;
test_input := ["Blueprint 1:  Each ore robot costs 4 ore.  Each clay robot costs 2 ore.  Each obsidian robot costs 3 ore and 14 clay.  Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2:  Each ore robot costs 2 ore.  Each clay robot costs 3 ore.  Each obsidian robot costs 3 ore and 8 clay.  Each geode robot costs 3 ore and 12 obsidian.
"];
test_ans := [[33], [62*56]];

import "advent-prelude.noul";
import "lib.noul";
puzzle_input := advent_input();


types := 0 til 4;
geode, obs, clay, ore := types;

names := {geode:"geode", obs:"obs", clay:"clay", ore:"ore"};

solve := freeze \bp_line, minutes -> (
	bp_id, ore_bot_cost, clay_bot_cost, obs_bot_ore_cost, obs_bot_clay_cost, geode_bot_ore_cost, geode_bot_obs_cost := ints bp_line;
    costs := [
    	V(0, geode_bot_obs_cost, 0, geode_bot_ore_cost), #geode
    	V(0, 0, obs_bot_clay_cost, obs_bot_ore_cost), # obs
    	V(0, 0, 0, clay_bot_cost), # clay
    	V(0, 0, 0, ore_bot_cost), # ore
    ];
    e := 0 .*4 then vector then (.* 4); for(i <- 0 til 4) e[i][i] = 1;
    max_ore_cost := max(ore_bot_cost, clay_bot_cost, obs_bot_ore_cost, geode_bot_ore_cost);

    print! costs;

	optimal := memoize \t -> t * (t-1) // 2;

    has_bots := \t, bots -> (
        if (t == obs) return bots[clay] > 0; 
        if (t == geode) return bots[obs] > 0; 
        return true;
  	);

	unecessary := \bots -> bots[ore] > max_ore_cost and bots[clay] > obs_bot_clay_cost and bots[obs] > geode_bot_obs_cost;
	# can_afford := \t, resources -> (resources - costs[t]) all (>=0) ;

    ans := 0;

	dfs := \res, bots, minutes, next -> 
	(
    	if (
        	next == ore and bots[ore] > max_ore_cost
        	or next == clay and bots[clay] > obs_bot_clay_cost
        	or next == obs and bots[obs] > geode_bot_obs_cost
        	or res[geode] + bots[geode]*minutes + optimal(minutes) <= ans
        	)
        	return;

    	while (switch (next)
        	case 0 -> (res[ore] < geode_bot_ore_cost) or (res[obs] < geode_bot_obs_cost)
        	case 1 -> res[ore] < obs_bot_ore_cost or res[clay] < obs_bot_clay_cost
        	case 2 -> res[ore] < clay_bot_cost
        	case 3 -> res[ore] < ore_bot_cost)
        (
            res += bots; ans max= res[geode];
            minutes -= 1; if (minutes==0) return;
        );
		res -= costs[next];
        res += bots; ans max= res[geode];
        minutes -= 1; if (minutes == 0) return;
		bots[next] += 1;
		for (t<-types) dfs(res, bots, minutes, t);
    );
	for(t<-types) dfs(V(0,0,0,0), V(0,0,0,1), minutes, t);
	result:= [ans, bp_id];
 	print! result;
    result
);


check_submit! 2, \l, b -> (
    print l;
    results := list! for (bp <- (l.strip.lines)[:3]) yield solve(bp, 32);
    print results;
    scores := results map first #(apply *);
    print scores;
    ans := scores.product;
    print ans;
    ans
)
