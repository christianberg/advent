#!/usr/bin/env jq --slurp --raw-input -f

def solve:
  (.balls | first) as $ball |
  .boards[.i] |= map(map(select(. != $ball))) |
  if (.boards[.i] | map(length==0) | any) then
    if .boardcount==1 then
      $ball * (.boards[.i][:5] | flatten | add)
    else
      .i as $i |
      .boards |= del(.[$i]) |
      .boardcount -= 1 |
      .i = .i%.boardcount |
      solve
    end
  else
    .i = (.i+1)%.boardcount |
    if .i==0 then
      .balls |= .[1:]
    else
      .
    end |
    solve
  end 
;


split("\n\n") |
{balls: first, boards: .[1:]} |
.balls |= (split(",") | map(tonumber)) |
.boards |= map(
  split("\n") |
  map(
    select(length>0) |
    split(" ") |
    map(select(length>0) | tonumber)
  ) |
  . + transpose
) |
.boardcount = (.boards | length) |
.i = 0 |
solve 