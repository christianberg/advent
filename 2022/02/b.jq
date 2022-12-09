#!/usr/bin/env jq -rRsf
split("\n")[:-1] |
map(
  split(" ")
) |
map(
  {"X":0, "Y": 3, "Z": 6}[.[1]] +
  {
    "AX":3,
    "AY":1,
    "AZ":2,
    "BX":1,
    "BY":2,
    "BZ":3,
    "CX":2,
    "CY":3,
    "CZ":1
  }[.|join("")
]
) |
add

