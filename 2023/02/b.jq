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
  [
    (.games | map(.red // 0) | max),
    (.games | map(.green // 0) | max),
    (.games | map(.blue // 0) | max)
  ] |
  reduce .[] as $item (1; . * $item)
) |
add
