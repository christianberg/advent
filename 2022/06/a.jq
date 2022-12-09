#!/usr/bin/env jq -Rsf
split("\n")[0] |
split("") |
. as $input |
[range($len) | $input[.:]] |
transpose |
map(unique | length) |
{pos: $len, rem: .} |
until(.rem[0]==$len; .pos += 1 | .rem |= .[1:]) |
.pos
