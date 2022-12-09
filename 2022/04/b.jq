#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(",") |
  map(split("-") | map(tonumber)) |
  select(
    ((.[0][0]<=.[1][0]) and (.[0][1]>=.[1][0])) or
    ((.[0][0]>=.[1][0]) and (.[0][0]<=.[1][1]))
  )
) | length