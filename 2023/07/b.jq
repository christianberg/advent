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
      tonumber? // {A: 14, K: 13, Q: 12, J: 1, T: 10}[.]
    )
  ) |
  (.hand | map(select(.==1)) | length) as $jokers |
  if $jokers==5 then
    .type = [5]
  else
    .type = (
      .hand |
      map(select(.>1)) |
      group_by(.) |
      map(length) |
      sort |
      reverse |
      .[0] += $jokers
    )
  end
) |
sort_by([.type, .hand]) |
map(.bid) |
[., [range(1; length+1)]] |
transpose |
map(.[0]*.[1]) |
add