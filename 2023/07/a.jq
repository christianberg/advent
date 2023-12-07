#!/usr/bin/env jq -rRsf
split("\n") |
.[:-1] |
map(
  split(" ") |
  {hand: .[0], bid: .[1]} |
  .bid |= tonumber |
  .hand |= (
    split("") |
    map(
      tonumber? // {A: 14, K: 13, Q: 12, J: 11, T: 10}[.]
    )
  ) |
  .type = (
    .hand |
    group_by(.) |
    map(length) |
    sort |
    reverse
  )
) |
sort_by([.type, .hand]) |
map(.bid) |
[., [range(1; length+1)]] |
transpose |
map(.[0]*.[1]) |
add