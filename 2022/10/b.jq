#!/usr/bin/env jq -rRsf
(./"\n")[:-1] |
map(
  ./" " |
  if .[0]=="addx" then [0, .[1]|tonumber] else [0] end
) |
flatten |
[foreach .[] as $delta (1; . + $delta)] |
[[range(241) | .%40], [1]+.] |
transpose |
map(
  if (.[0]-.[1])<=1 and (.[1]-.[0])<=1 then "#" else "." end
) as $screen |
range(0;240;40) | ($screen[.:.+40]) | join("")
