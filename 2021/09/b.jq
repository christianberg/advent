#!/usr/bin/env jq --slurp --raw-input -f
def neighbors($height;$width):
  [
    if (.[0]>0) then ([.[0]-1,.[1]]) else empty end,
    if (.[0]<($height-1)) then [.[0]+1,.[1]] else empty end,
    if .[1]>0 then [.[0],.[1]-1] else empty end,
    if .[1]<($width-1) then [.[0],.[1]+1] else empty end
  ]
;

def expand_basin($input;$height;$width):
  . as $core |
  ((map(neighbors($height;$width)) | flatten(1) | unique) - $core |
  map(select($input[.[0]][.[1]]<9))) |
  if length>0 then
    ($core + .) | expand_basin($input;$height;$width)
  else
    $core
  end
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
  [.] |
  expand_basin($input;$height;$width) |
  length
) |
sort | reverse |
.[0]*.[1]*.[2]
