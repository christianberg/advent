#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(" ")
) |
map(
  {"X":1, "Y":2, "Z": 3}[.[1]] +
   if .[0]=={"X":"A","Y":"B","Z":"C"}[.[1]] then
     3
   else
     {"AY":6,"BZ":6,"CX":6}[.|join("")] // 0
   end
) |
add

