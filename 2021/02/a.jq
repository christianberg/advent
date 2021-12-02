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
transpose |
map(add) |
.[0]*.[1]