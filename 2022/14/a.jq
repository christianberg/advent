#!/usr/bin/env jq -Rsf
(./"\n")[:-1] |
map(
  ./" -> " |
  map(./"," | map(tonumber)) |
  [.[:-1],.[1:]] | transpose |
  map(
    transpose |
    map(sort | [range(.[0];.[1]+1)]) |
    combinations
  )
) |
flatten(1) |
(transpose[1] | max) as $floor |
map(tostring) |
reduce .[] as $pos ({}; .[$pos]="#") |
{map: ., x: 500, y: 0, units: 0} |
until(
  .y>$floor;
  .map as $map |
  if ([.x,.y+1] | tostring | in($map) | not) then
    .y += 1
  elif ([.x-1,.y+1] | tostring | in($map) | not) then
    .x -= 1 | .y += 1
  elif ([.x+1,.y+1] | tostring | in($map) | not) then
    .x += 1 | .y += 1
  else
    .map[[.x,.y]|tostring] = "o" |
    .units += 1 |
    .x = 500 |
    .y = 0
  end
) |
.units