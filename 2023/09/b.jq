#!/usr/bin/env jq -rRsf
split("\n") |
.[:-1] |
map(
  split(" ") |
  map(tonumber) |
  {sequence: ., first_elements: []} |
  until(
    .sequence | all(.==0);
    .first_elements += .sequence[:1] |
    .sequence |= (
      [.[:-1],.[1:]] |
      transpose |
      map(.[1]-.[0])
    )
  ) |
  .first_elements |
  reverse |
  reduce .[] as $i (0; $i - .)
) |
add