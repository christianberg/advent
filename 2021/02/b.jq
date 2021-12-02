#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" ") |
  .[1] |= tonumber |
  if .[0]=="forward" then
    [0,.[1]]
  elif .[0]=="down" then
    [.[1],0]
  else
    [-1*.[1],0]
  end
) |
reduce .[] as $step (
  [0,0,0];
  [.[0]+$step[0],.[1]+.[0]*$step[1],.[2]+$step[1]]
) |
.[1]*.[2]