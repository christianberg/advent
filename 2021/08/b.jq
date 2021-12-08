#!/usr/bin/env jq --slurp --raw-input -f

{
  "abcefg": 0,
  "cf": 1,
  "acdeg": 2,
  "acdfg": 3,
  "bcdf": 4,
  "abdfg": 5,
  "abdefg": 6,
  "acf": 7,
  "abcdefg": 8,
  "abcdfg": 9
} as $todigit |

split("\n") | .[:-1] |
map(
  split(" | ") |
  map(
    split(" ") | map(split(""))
  ) |
  (
    .[0] |
    (map(select(length==2)) | .[0]) as $c_or_f |
    (map(select(length==3)) | .[0] | . - $c_or_f | .[0]) as $a |
    (map(select(length==4)) | .[0] | . - $c_or_f) as $b_or_d |
    . as $full |
    map(select(length==5)) |
    (.[2]-(.[2]-(.[0]-(.[0]-.[1])))) as $a_or_d_or_g |
    ((($a_or_d_or_g - [$a]) - $b_or_d) | .[0]) as $g |
    (($a_or_d_or_g - [$a, $g]) | .[0]) as $d |
    (($b_or_d - [$d]) | .[0]) as $b |
    ((add | unique) - ([$a, $b, $d, $g] + $c_or_f) | .[0]) as $e |
    $full | map(select(length==6)) |
    map(select(contains([$a,$b,$d,$e,$g]))) | .[0] |
    (. - [$a, $b, $d, $e, $g] | .[0]) as $f |
    ($c_or_f - [$f] | .[0]) as $c |
    {($a): "a", ($b): "b", ($c): "c", ($d): "d", ($e): "e", ($f): "f", ($g): "g"}
  ) as $decode |
  [
    .[1] |
    map(map($decode[.]) | sort | join("") | $todigit[.]),
    [1000,100,10,1]
  ] |
  transpose |
  map(.[0]*.[1]) |
  add
) |
add
