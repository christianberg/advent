#!/usr/bin/env jq -Rsf
def find($char):
  . as $map |
  (.[0] | length) as $width |
  ($char|explode)[0] as $codepoint |
  {i:0, x:0, y:0} |
  until($map[.x][.y]==$codepoint; .i+=1 | .x=(.i/$width | floor) | .y=.i%$width) |
  [.x,.y]
;

("a"|explode)[0] as $a |
("z"|explode)[0] as $z |
(./"\n")[:-1] | map(explode) |
find("S") as $start |
find("E") as $goal |
setpath($start; $a) |
setpath($goal; $z) |

. as $map |
length as $height |
(.[0]|length) as $width |

def neighbors:
  [
    if .[0]>0 then [.[0]-1,.[1]] else empty end,
    if .[0]<($height-1) then [.[0]+1,.[1]] else empty end,
    if .[1]>0 then [.[0],.[1]-1] else empty end,
    if .[1]<($width-1) then [.[0],.[1]+1] else empty end
  ]
;

def astar:
  .candidates |= (
    group_by(.pos) |
    map(sort_by(.estimated_cost) | first) |
    sort_by(.estimated_cost)
  ) |
  (.candidates | first) as $cand |
  .candidates |= .[1:] |
  if (($map | getpath($cand.pos)) == $a) then
    $cand
  else
    .visited[$cand.pos | tostring] = true |
    .visited as $v |
    ($map | getpath($cand.pos)) as $height |
    .candidates += (
      $cand.pos |
      neighbors |
      map(
        select((.|tostring) as $x | $v | has($x) | not) |
        select($map[.[0]][.[1]]>=($height-1)) |
        ($cand.cost+1) as $cost |
        {
          pos: .,
          cost: $cost,
          estimated_cost: ($cost + $map[.[0]][.[1]] - $a)
        }
      )
    ) |
    astar
  end
;

{candidates: [{pos: $goal, cost: 0, estimated_cost: ($z-$a)}], visited: {}} |
astar |
.cost