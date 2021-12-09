#!/usr/bin/env jq --slurp --raw-input -f
def neighbors($height;$width):
  [
    if .[0]>0 then [.[0]-1,.[1]] else empty end,
    if .[0]<($height-1) then [.[0]+1,.[1]] else empty end,
    if .[1]>0 then [.[0],.[1]-1] else empty end,
    if .[1]<($width-1) then [.[0],.[1]+1] else empty end
  ]
;

split("\n") | .[:-1] |
map(split("") | map(tonumber)) |
length as $height |
(.[0] | length) as $width |
. as $input |
[[range($height)],[range($width)]] |
[combinations] |
map(
  select(
    ($input[.[0]][.[1]]) <
    (
      neighbors($height;$width) |
      map($input[.[0]][.[1]]) |
      min
    )
  ) |
  $input[.[0]][.[1]] |
  . + 1
) |
add
