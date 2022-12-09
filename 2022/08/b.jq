#!/usr/bin/env jq -Rsf

def scores:
reduce .[] as $tree (
  {view_levels: [0,0,0,0,0,0,0,0,0,0], scores: []};
  .scores += [.view_levels[$tree]] |
  .view_levels |= ([[range(10)],.] | transpose | map(if .[0]<=$tree then 1 else .[1]+1 end))
) | .scores
;

split("\n")[:-1] |
map(
  split("") |
  map(tonumber)
) |
[., transpose] |
map(
  [., map(reverse)] |
  map(map(scores)) |
  .[1] |= map(reverse)
) |
.[1] |= map(transpose) |
add |
map(flatten) |
transpose |
map(reduce .[] as $i (1; . * $i)) |
max