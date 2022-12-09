#!/usr/bin/env jq -rRsf

def look:
  {rem: ., max: -1, res: []} |
  [until((.rem | length)==0;
    .res += if .rem[0]>.max then [1] else [0] end |
    .max = ([.max, .rem[0]] | max) |
    .rem |= .[1:]
  )][0].res;

split("\n")[:-1] |
map(
  split("") |
  map(tonumber)
) |
[
map (
  [look, (reverse | look | reverse)] |
  transpose | map(add)
),
(transpose |
map (
  [look, (reverse | look | reverse)] |
  transpose | map(add)
) |
transpose)
] |
transpose |
map(transpose | map(add)) |
flatten |
map(select(.>0)) |
length