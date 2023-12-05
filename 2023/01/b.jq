#!/usr/bin/env jaq -rRsf
def first_digit($s):
  $s |
  [
    (.[0:1] | tonumber?),
    if startswith("one") then 1 else null end,
    if startswith("two") then 2 else null end,
    if startswith("three") then 3 else null end,
    if startswith("four") then 4 else null end,
    if startswith("five") then 5 else null end,
    if startswith("six") then 6 else null end,
    if startswith("seven") then 7 else null end,
    if startswith("eight") then 8 else null end,
    if startswith("nine") then 9 else null end
  ]
  | map(select(.))
  | .[0] // first_digit($s[1:])
;

def last_digit($s):
  $s |
  [
    (.[-1:] | tonumber?),
    if endswith("one") then 1 else null end,
    if endswith("two") then 2 else null end,
    if endswith("three") then 3 else null end,
    if endswith("four") then 4 else null end,
    if endswith("five") then 5 else null end,
    if endswith("six") then 6 else null end,
    if endswith("seven") then 7 else null end,
    if endswith("eight") then 8 else null end,
    if endswith("nine") then 9 else null end
  ]
  | map(select(.))
  | .[0] // last_digit($s[:-1])
;

split("\n")[:-1]
| map(
  [first_digit(.), last_digit(.)]
  | map(tostring)
  | add
  | tonumber
)
| add
