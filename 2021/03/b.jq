#!/usr/bin/env jq --slurp --raw-input -f
def find($l; $i; maybe_not):
  if $l==1 then
    .[0]
  else
    . as $input |
    0 |
    until(
      $input[.][$i]==1;
      .+=1
    ) |
    if (. > ($l-.)) | maybe_not then
      . as $cut |
      $input[:$cut] | find($cut; $i+1; maybe_not)
    else
      . as $cut |
      $input[$cut:] | find($l-$cut; $i+1; maybe_not)
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
[find($l; 0; .), find($l; 0; not)] |
map(decimal) |
.[0]*.[1]
