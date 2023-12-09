#!/usr/bin/env jq -rRsf
split("\n") |
.[:-1] |
map(
  split(" ") |
  map(tonumber) |
  {sequence: ., last_elements: []} |
  until(
    .sequence | all(.==0);
    .last_elements += .sequence[-1:] |
    .sequence |= (
      [.[:-1],.[1:]] |
      transpose |
      map(.[1]-.[0])
    )
  ) |
  .last_elements |
  add
) |
add