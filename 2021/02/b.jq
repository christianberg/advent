#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" ") |
  {(.[0]): (.[1]|tonumber)} |
  {forward, down, up}
) |
reduce .[] as $step (
  {aim: 0, pos: 0, depth: 0};
  .aim += ($step.down//0) - ($step.up//0) |
  .pos += $step.forward//0 |
  .depth += (($step.forward//0) * .aim)
) |
.pos * .depth