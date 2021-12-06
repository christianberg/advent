#!/usr/bin/env jq --slurp --raw-input -f
split(",") | map(tonumber) |
group_by(.) | sort |
{generation: 0,
 population: ([0]+map(length))} |
until(
  .generation == 256; # this is part 2, put 80 for part 1
  .generation += 1 |
  (.population[0]//0) as $spawn |
  .population |= .[1:] |
  .population[6] += $spawn |
  .population[8] = $spawn
) |
.population | add