#!/usr/bin/env jq -rRsf
.[:-1] |
split("\n") |
map(
  split("\\s+"; "g") |
  .[1:] |
  map(tonumber)
) |
transpose |
map({time: .[0], record: .[1]}) |
map(
  . as $this |
  [range(.time)] |
  map(
    (. * ($this.time - .)) |
    select(. > $this.record)
  ) |
  length
) |
reduce .[] as $i (1; . * $i)
