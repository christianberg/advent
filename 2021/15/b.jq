#!/usr/bin/env jq -s -R -f
split("\n") | .[:-1] |
map(split("") | map(tonumber)) |
. as $map |
length as $tile_height |
($tile_height * 5) as $height |
(.[0]|length) as $tile_width |
($tile_width * 5) as $width |
[$height-1,($width-1)] as $goal |

def neighbors:
  [
    if .[0]>0 then [.[0]-1,.[1]] else empty end,
    if .[0]<($height-1) then [.[0]+1,.[1]] else empty end,
    if .[1]>0 then [.[0],.[1]-1] else empty end,
    if .[1]<($width-1) then [.[0],.[1]+1] else empty end
  ]
;

def get_cost:
  (.[0]%$tile_height) as $x |
  (.[1]%$tile_width) as $y |
  (.[0]/$tile_height|floor) as $tx |
  (.[1]/$tile_width|floor) as $ty |
  ($map[$x][$y]+$tx+$ty) % 9 |
  if .==0 then 9 else . end
;

def astar:
  .candidates |= (
    group_by(.pos) |
    map(sort_by(.estimated_cost) | first) |
    sort_by(.estimated_cost)
  ) |
  (.candidates | first) as $cand |
  .candidates |= .[1:] |
  if ($cand.pos == $goal) then
    $cand
  else
    .visited[$cand.pos | tostring] = true |
    .visited as $v |
    .candidates += (
      $cand.pos |
      neighbors |
      map(
        select((.|tostring) as $x | $v | has($x) | not) |
        ($cand.cost + get_cost) as $cost |
        {
          pos: .,
          cost: $cost,
          estimated_cost: ($cost + $goal[0]-.[0] + $goal[1]-.[1])
        }
      )
    ) |
    astar
  end
;

{candidates: [{pos: [0,0], cost: 0, estimated_cost: 0}], visited: {}} |
astar