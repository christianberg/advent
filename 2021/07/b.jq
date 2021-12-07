#!/usr/bin/env jq --slurp --raw-input -f
def abs:
  if (. < 0) then (-1 * .) else . end;

split(",") | map(tonumber) |
. as $input |
[range(min; max+1)] |
map(
  . as $cand |
  $input |
  map((. - $cand) | abs | (. * (.+1) / 2)) |
  add
) |
min