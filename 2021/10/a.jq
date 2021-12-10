#!/usr/bin/env jq --slurp --raw-input -f
["(","[","{","<"] as $opening |
{")":"(", "]":"[", "}":"{", ">":"<"} as $match |
{")": 3, "]": 57, "}": 1197, ">": 25137} as $score |

def get_score:
  (.rest | first) as $x |
  if $x|not then
    0
  elif ($opening | contains([$x])) then
    .stack |= [$x]+. |
    .rest |= .[1:] |
    get_score
  elif ($match[$x]==.stack[0]) then
    .stack |= .[1:] |
    .rest |= .[1:] |
    get_score
  else
    $score[$x]
  end
;

split("\n") | .[:-1] |
map(
  split("") |
  {stack: [], rest: .} |
  get_score
) |
add