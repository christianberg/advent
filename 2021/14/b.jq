#!/usr/bin/env jq -s -R -f

def combine:
  reduce (map(to_entries)|flatten(1))[] as $item (
    {};
    .[$item.key] += $item.value
  )
;

split("\n\n") |
(
  .[1] |
  split("\n") | .[:-1] |
  map(split(" -> ") | {key: .[0], value: .[1]}) |
  from_entries
) as $rules |

def grow:
  if .cache[.depth][.start+.stop] then
    .result = .cache[.depth][.start+.stop]
  else
    if .depth == 0 then
      .result = ([{(.start): 1},{(.stop): 1}] | combine)
    else
      $rules[.start+.stop] as $middle |
      . += (
        . | {start, stop: $middle, depth: (.depth-1), cache} |
        grow |
        {cache, left_result: .result}
      ) |
      . += (
        . | {start: $middle, stop, depth: (.depth-1), cache} |
        grow |
        {cache, right_result: .result}
      ) |
      .result = ([
        .left_result,
        {($middle): -1},
        .right_result
      ] | combine)
    end |
    .cache[.depth][.start+.stop] = .result
  end
;

.[0] |
split("") |
(.[1:-1] | map({(.): -1})) as $middles |
[.[:-1],.[1:]] |
transpose |
map(
  {
    start: .[0],
    stop: .[1],
    depth: ($ARGS.named.depth // 10)
  } |
  grow |
  .result
) |
. + $middles |
combine |
map(.) |
sort |
.[-1]-.[0]