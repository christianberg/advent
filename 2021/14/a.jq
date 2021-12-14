#!/usr/bin/env jq -s -R -f

def grow:
  if .steps == 0 then
    .
  else
    .steps -= 1 |
    .rules as $rules |
    .template |= (
      .[-1] as $last |
      [.[:-1],.[1:]] |
      transpose |
      map([.[0], (join("") | $rules[.])]) |
      add + [$last]
    ) |
    grow
  end
;

split("\n\n") |
{
  template: .[0] | split(""),
  rules: (
    .[1] |
    split("\n") | .[:-1] |
    map(split(" -> ") | {key: .[0], value: .[1]}) |
    from_entries
  ),
  steps: 10
} |
grow |
.template |
group_by(.) |
map(length) |
sort |
.[-1]-.[0]