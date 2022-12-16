#!/usr/bin/env jq -Rsf

def abs:
  if .<0 then -1*. else . end
;

(./"\n")[:-1] |
map(
  capture("Sensor at x=(?<sx>-?[0-9]+), y=(?<sy>-?[0-9]+): closest beacon is at x=(?<bx>-?[0-9]+), y=(?<by>-?[0-9]+)") |
  map_values(tonumber) |
  {sensor: [.sx,.sy], beacon: [.bx,.by]}
) |
(
  map(.beacon | select(.[1]==$row) | .[0]) | unique | length
) as $beacons_in_row |
map(
  .range = ((.sensor[0]-.beacon[0])|abs) + ((.sensor[1]-.beacon[1])|abs) |
  .row_range = .range - (($row - .sensor[1]) | abs) |
  select(.row_range > 0) |
  [.sensor[0]-.row_range, .sensor[0]+.row_range]
) |
sort |
reduce .[1:][] as $next (
  {covered: 0, current: .[0]};
  if .current[1] < $next[0] then
    .covered += .current[1] - .current[0] + 1 |
    .current = $next
  else
    .current[1] = ([.current[1], $next[1]] | max)
  end
) |
.covered + .current[1] - .current[0] + 1 - $beacons_in_row