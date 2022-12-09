#!/usr/bin/env jq -rRsf
split("\n")[:-1] as $input |
[range(0;$input|length;3)] |
map(
  $input[.:.+3] |
  map(
    split("") |
    unique |
    map({(.):1}) |
    add
  ) |
  . as $foo |
  .[0] | keys |
  map(select($foo[1][.]+$foo[2][.]==2))[0]
) |
join("") |
explode | map(if .>=97 then .-96 else .-38 end) |
add