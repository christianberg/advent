#!/usr/bin/env jq --slurp --raw-input -f
split(",") | map(tonumber) |
[[range(min; max+1)],.] |
[combinations] |
group_by(first) |
map(
  map(max - min) | add
) |
min
