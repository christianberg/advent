#!/usr/bin/env jq -rRsf
{
  N: [-1,0],
  E: [0,1],
  S: [1,0],
  W: [0,-1]
} as $move |
{
  N: {"|": "N", "F": "E", "7": "W"},
  E: {"-": "E", "7": "S", "J": "N"},
  S: {"|": "S", "L": "E", "J": "W"},
  W: {"-": "W", "L": "N", "F": "S"}
} as $turn |
split("\n") |
.[:-1] |
map(
  split("")
) |
. as $map |
(
    [[range(length)],[range(.[0]|length)]] |
    [combinations] |
    map(
      select($map[.[0]][.[1]]=="S")
    ) |
    .[0]
) as $start |
["N", "E", "S", "W"] |
map(
  {
    previous_move: .,
    position: [$start, $move[.]] | transpose | map(add),
    next_move: $turn[.][[$start, $move[.]] | transpose | map(add) | $map[.[0]][.[1]]],
    step: 1
  } |
  select(.next_move)
) |
until(
  .[0].position == .[1].position;
  map(
    .step += 1 |
    .previous_move = .next_move |
    .position = ([.position, $move[.previous_move]] | transpose | map(add)) |
    .next_move = $turn[.previous_move][.position | $map[.[0]][.[1]]]
  )
) |
.[0].step

