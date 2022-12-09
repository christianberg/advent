#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(split(" ") | .[0]*(.[1]|tonumber)) |
join("") | split("") |
map(
  {"R": [1,0], "L": [-1,0], "U": [0,1], "D": [0,-1]}[.]
) |
[foreach .[] as $step ([0,0]; [.[0]+$step[0],.[1]+$step[1]]; .)] |
reduce range(9) as $_ (.;
[foreach .[] as $head (
  [0,0];
  if (.[0]-$head[0])>1 or (.[0]-$head[0])<-1 or (.[1]-$head[1])>1 or (.[1]-$head[1])<-1 then
    .[0] |= . + ([([($head[0]-.),1] | min),-1] | max) |
    .[1] |= . + ([([($head[1]-.),1] | min),-1] | max) 
  else
    .
  end;
  .
)]) |
unique | length