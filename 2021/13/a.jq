#!/usr/bin/env jq --slurp --raw-input -f
split("\n\n") | map(split("\n")) |
{dots: (
  .[0] |
  map(split(",") | map(tonumber))
),
instructions: .[1][:-1] | map({dir: .[11:12], pos: .[13:]|tonumber}) | .[0]
} |
reduce .instructions as $instruction (
  .dots;
  map(
    if ($instruction["dir"] == "x") and (.[0]>$instruction["pos"]) then
      .[0] |= ((2*$instruction["pos"]) - .)
    elif ($instruction["dir"] == "y") and (.[1]>$instruction["pos"]) then
      .[1] |= ((2*$instruction["pos"]) - .)
    else
      .
    end
  )
) | unique | length
