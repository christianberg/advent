#!/usr/bin/env jq --slurp --raw-input -f
def get_cut_position($index):
  . as $input |
  0 | until($input[.][$index]==1; .+=1);

def find($l; $i; maybe_not):
  if $l==1 then
    first
  else
    get_cut_position($i) as $cut |
    if ($cut > ($l-$cut)) | maybe_not then
      .[:$cut] | find($cut; $i+1; maybe_not)
    else
      .[$cut:] | find($l-$cut; $i+1; maybe_not)
    end
  end;

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
map(split("") | map(tonumber)) |
[find($l; 0; .), find($l; 0; not)] |
map(decimal) |
.[0]*.[1]
