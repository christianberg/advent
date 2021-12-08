#!/usr/bin/env jq --slurp --raw-input -f
split("\n") | .[:-1] |
map(
  split(" | ") | .[1] |
  split(" ") |
  map(length | select(.==2 or .==3 or .==4 or .==7))
) |
flatten |
length