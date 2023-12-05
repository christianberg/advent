#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map("." + . + ".") |
[., ["."*(.[0]|length)]+.[:-1], .[1:]+["."*(.[0]|length)], [range(length)]] |
transpose |
map(
  . as $lines |
  [.[0] | match("\\d+"; "g")] |
  map(
    {
      "number": (.string | tonumber),
      "line": $lines[3],
      "col": .offset,
      "surround": (
        $lines[1][.offset-1:.offset+.length+1] +
        $lines[0][(.offset-1):.offset] +
        (" " * .length) +
        $lines[0][(.offset+.length):(.offset+.length+1)] +
        $lines[2][.offset-1:.offset+.length+1]
      )
    } |
    .gearmatch = (.surround | match("\\*"; "g"))
  )
) |
flatten |
map(
  select(.gearmatch) |
  .boxlen = (((.surround | length) / 3) | floor) |
  .gearrow = (((.gearmatch.offset / .boxlen) | floor) + .line) |
  .gearcol = ((.gearmatch.offset % .boxlen) + .col) |
  {
    number,
    gear: [.gearrow, .gearcol]
  }
) |
[combinations(2)] |
map(
  select(.[0].number < .[1].number) |
  select(.[0].gear == .[1].gear) |
  .[0].number * .[1].number
) |
add
