#!/usr/bin/env jq -rRsf
.[:-1] |
split("\n\n") |
{
  turns: (.[0] | split("") | map({L: 0, R: 1}[.])),
  nodes: (
    .[1] |
    split("\n") |
    map(
      split(" = ") |
      {(.[0]): (.[1][1:-1] | split(", "))}
    ) |
    add
  )
} |
.this = "AAA" |
.steps = 0 |
until(
  .this == "ZZZ";
  .steps += 1 |
  .this = .nodes[.this][.turns[0]] |
  .turns |= (.[1:] + .[0:1])
) |
.steps
