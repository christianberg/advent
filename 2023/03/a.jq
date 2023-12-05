#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map("." + . + ".") |
[., [""]+.[:-1], .[1:]+[""]] |
transpose |
map(
  . as $lines |
  [.[0] | match("\\d+"; "g")] |
  map(
    {
      "number": (.string | tonumber),
      "surround": (
        $lines[0][(.offset-1):.offset] +
        $lines[0][(.offset+.length):(.offset+.length+1)] +
        $lines[1][.offset-1:.offset+.length+1] +
        $lines[2][.offset-1:.offset+.length+1]
      )
    }
  )
) |
flatten |
map(
  select(.surround | test("[^.0-9]")) |
  .number
) |
add
