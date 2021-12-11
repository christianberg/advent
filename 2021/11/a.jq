#!/usr/bin/env jq --slurp --raw-input -f
def neighbors:
  . as $center |
  [
    [range([0,.[0]-1]|max;[10,.[0]+2]|min)],
    [range([0,.[1]-1]|max;[10,.[1]+2]|min)]
  ] |
  [combinations] |
  map(select(. != $center))
;

def flash:
  .state as $state |
  .flashing = (
    [[range(10)],[range(10)]] |
    [combinations] |
    map(select($state[.[0]][.[1]]>9))
  ) - .flashed |
  if (.flashing | length) == 0 then
    .flashcount += (.flashed | length)
  else 
    reduce (.flashing[] | neighbors[]) as $i (
      .;
      .state[$i[0]][$i[1]] += 1
    ) |
    .flashed += .flashing |
    flash
  end
;

def step:
  if .steps == 0 then
    .
  else
    .steps -= 1 |
    .state[][] += 1 |
    .flashed = [] |
    flash |
    (.state[][] | select(.>9)) = 0 |
    step
  end
;

split("\n") | .[:-1] |
map(
  split("") | map(tonumber)
) |
{state: ., flashcount: 0, steps: 100} |
step |
.flashcount