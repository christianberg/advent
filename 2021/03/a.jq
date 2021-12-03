#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split("") |
  map({"1":1,"0":-1}[.])
) |
transpose |
reverse |
map(add) |
reduce .[] as $i (
  {gamma: 0, epsilon: 0, power: 1};
  if $i>0 then
    .gamma += .power
  else
    .epsilon += .power
  end |
  .power *= 2
) |
.gamma * .epsilon