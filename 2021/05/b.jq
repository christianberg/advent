#!/usr/bin/env jq --slurp --raw-input -f
def get_range($dir):
  (if .[0][$dir] <= .[1][$dir] then
    1
  else
    -1
  end) as $step |
  [range(.[0][$dir]; .[1][$dir]+$step; $step)]
;


split("\n") | .[:-1] |
map(
  split(" -> ") |
  map(split(",") | map(tonumber)) |
  [get_range(0), get_range(1)] |
  if ((.[0] | length)==1 or (.[1] | length)==1) then
    combinations
  else
    transpose | .[]
  end
) |
group_by(.) |
map(select(length>1)) |
length
