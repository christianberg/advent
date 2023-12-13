#!/usr/bin/env jq -rRsf
split("\n") |
.[:-1] |
length as $height |
(.[0] | length) as $width |
[map(indices("#")), ([range(length)] | map([.]))] |
transpose |
map(combinations) |
([range($height)] - map(.[1])) as $emptyrows |
([range($width)] - map(.[0])) as $emptycols |
map(
  .[0] |= (. as $this | . + ($emptycols | map(select(. < $this)) | length * 999999)) |
  .[1] |= (. as $this | . + ($emptyrows | map(select(. < $this)) | length * 999999))
) |
[combinations(2)] |
map(select(.[0]!=.[1]) | sort) |
unique |
map(
  .[1][0]-.[0][0] + ((.[1][1]-.[0][1]) | abs)
) |
add