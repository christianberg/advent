#!/usr/bin/env jq --slurp --raw-input -f
["(","[","{","<"] as $opening |
{")":"(", "]":"[", "}":"{", ">":"<"} as $match |
{"(": 1, "[": 2, "{": 3, "<": 4} as $score |

def calc_unbalanced:
  (.stack | first) as $x |
  if $x|not then
    .score
  else
    .score *= 5 |
    .score += $score[$x] |
    .stack |= .[1:] |
    calc_unbalanced
  end
;

def get_score:
  (.rest | first) as $x |
  if $x|not then
    {score:0, stack: .stack} |
    calc_unbalanced
  elif ($opening | contains([$x])) then
    .stack |= [$x]+. |
    .rest |= .[1:] |
    get_score
  elif ($match[$x]==.stack[0]) then
    .stack |= .[1:] |
    .rest |= .[1:] |
    get_score
  else
    empty
  end
;

split("\n") | .[:-1] |
map(
  split("") |
  {stack: [], rest: .} |
  get_score
) |
sort |
.[(length-1)/2]