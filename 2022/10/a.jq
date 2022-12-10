#!/usr/bin/env jq -Rsf
(./"\n")[:-1] |
map(
  ./" " |
  if .[0]=="addx" then [0, .[1]|tonumber] else [0] end
) |
flatten |
[foreach .[] as $delta (1; . + $delta)] as $values |
[range(20;221;40)] |
map(. * $values[.-2]) | add