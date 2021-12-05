#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" -> ") |
  map(split(",") | map(tonumber)) |
  select((.[0][0]==.[1][0]) or (.[0][1]==.[1][1])) |
  ([.[0][0],.[1][0]] | sort) as $hor |
  ([.[0][1],.[1][1]] | sort) as $ver |
  [[range($hor[0];$hor[1]+1)],[range($ver[0];$ver[1]+1)]] |
  combinations
) | 
group_by(.) |
map(select(length>1)) |
length
