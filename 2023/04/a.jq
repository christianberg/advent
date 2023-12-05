#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(":") | .[1] |
  split(" | ") |
  map(split(" ") | map(tonumber?)) |
  ((.[0]+.[1]) | unique) - (.[0]-.[1]) - (.[1]-.[0]) |
  length |
  select(.>0) |
  pow(2; .-1)
) |
add