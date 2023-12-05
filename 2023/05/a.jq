#!/usr/bin/env jq -rRsf
.[:-1] |
split("\n\n") |
map(
  split("\n")
) |
(
  .[1:] |
  map(
    .[1:] |
    map(
      split(" ") |
      map(tonumber) |
      {dest: .[0], source: .[1], len: .[2]}
    ) |
    sort_by(.source)
  )
) as $mappings |
(.[0][0] | split(" ")[1:] | map(tonumber)) |
map(
  {val: ., mappings: $mappings} |
  until(
    (.mappings | length) == 0;
    if ((.mappings[0] | length) == 0) then
      .mappings |= .[1:]
    elif (.val < .mappings[0][0].source) then
      .mappings |= .[1:]
    elif (.val < (.mappings[0][0].source + .mappings[0][0].len)) then
      .val = (.val - .mappings[0][0].source + .mappings[0][0].dest) |
      .mappings |= .[1:]
    else
      .mappings[0] |= .[1:]
    end
  ) |
  .val
) |
min