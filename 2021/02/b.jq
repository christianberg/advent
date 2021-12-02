#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" ") |
  {(.[0]): (.[1]|tonumber)} |
  {forward, down, up} |
  map_values(.//0)
) |
reduce .[] as $step (
  {aim: 0, pos: 0, depth: 0};
  .aim += $step.down - $step.up |
  .pos += $step.forward |
  .depth += $step.forward * .aim
) |
.pos * .depth