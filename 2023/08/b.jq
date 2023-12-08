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
.steps = 0 |
. as $initial_state |
(.nodes | keys | map(select(.[-1:]=="A"))) |
map(
  . as $this |
  $initial_state |
  .this = $this |
until(
  (.this == .first_z) and (.turns == .turns_at_first_z) and (.cycle_length>0);
  .steps += 1 |
  .cycle_length += 1 |
  .this = .nodes[.this][.turns[0]] |
  .turns |= (.[1:] + .[0:1]) |
  if (.this[-1:]=="Z" and (.first_z | not)) then
    .first_z = .this |
    .turns_at_first_z = .turns |
    .steps_to_first_z = .steps |
    .cycle_length = 0
  else
    .
  end
) |
.cycle_length
) |
until(
  length == 1;
  [
    [.[0],.[1]] |
    (
      until(
        (.[0] % .[1]) == 0;
        [.[1], (.[0] % .[1])]
      ) |
      .[1]
    ) as $gcd |
    (.[0] / $gcd) * .[1]
  ] + .[2:]
) |
.[0]
