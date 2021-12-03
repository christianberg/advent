#!/usr/bin/env jq --slurp --raw-input -f
def more($l; $i):
  if $l==1 then
    .[0]
  else
    . as $input |
    0 |
    until(
      $input[.][$i]==1;
      .+=1
    ) |
    if . > ($l-.) then
      . as $cut |
      $input[:$cut] | more($cut; $i+1)
    else
      . as $cut |
      $input[$cut:] | more($l-$cut; $i+1)
    end
  end
;

def less($l; $i):
  if $l==1 then
    .[0]
  else
    . as $input |
    0 |
    until(
      $input[.][$i]==1;
      .+=1
    ) |
    if . <= ($l-.) then
      . as $cut |
      $input[:$cut] | less($cut; $i+1)
    else
      . as $cut |
      $input[$cut:] | less($l-$cut; $i+1)
    end
  end
;

def decimal:
  reverse |
  reduce .[] as $digit (
    {result: 0, power: 1};
    .result += $digit * .power |
    .power *= 2
  ) |
  .result
;

split("\n") | .[:-1] |
sort | length as $l |
map(split("") |map(tonumber)) |
[more($l; 0), less($l; 0)] |
map(decimal) |
.[0]*.[1]
