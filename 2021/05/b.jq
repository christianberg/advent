#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" -> ") |
  map(split(",") | map(tonumber)) |
  transpose |
  map(
    (if .[0] <= .[1] then 1 else -1 end) as $step |
    [range(.[0]; .[1]+$step; $step)]
  ) |
  if (map(length) | min) == 1 then
    combinations
  else
    transpose | .[]
  end
) |
group_by(.) |
map(select(length>1)) |
length
