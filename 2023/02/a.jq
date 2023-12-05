#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(": ") |
  {
    id: (.[0] | split(" ")[1] | tonumber),
    games: (
      .[1] |
      split("; ") |
      map(
        split(", ") |
	map(split(" ") | {(.[1]): (.[0]|tonumber)}) |
	add
      )
    )
  }
) |
map(
  select((.games | map(.red // 0) | max) <= 12) |
  select((.games | map(.green // 0) | max) <= 13) |
  select((.games | map(.blue // 0) | max) <= 14) |
  .id
) |
add
