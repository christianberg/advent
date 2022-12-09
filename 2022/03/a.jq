#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  [.[:length/2],.[length/2:]] |
  map(split("")) |
  [combinations |
  select(.[0]==.[1])] |
  .[0][0]
) |
join("") |
explode | map(if .>=97 then .-96 else .-38 end) |
add