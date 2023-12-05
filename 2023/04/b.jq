#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(":") | .[1] |
  split(" | ") |
  map(split(" ") | map(tonumber?)) |
  ((.[0]+.[1]) | unique) - (.[0]-.[1]) - (.[1]-.[0]) |
  {count: 1, wins: length}
) |
{total: 0, rest: .} |
until(
  (.rest | length)==0;
  .rest[0] as $this |
  .rest |= .[1:] |
  .rest[range($this.wins)].count += $this.count |
  .total += $this.count
) |
.total