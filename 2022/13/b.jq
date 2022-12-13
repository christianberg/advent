#!/usr/bin/env jq -sf

def right_order:
  if .[0][0]==.[1][0] then
    [.[0][1:],.[1][1:]] | right_order
  else
    (.[0][0]|tonumber? // false) as $l |
    (.[1][0]|tonumber? // false) as $r |
    if .[0]==[] then
      true
    elif .[1]==[] then
      false
    elif $l and $r then
      $l < $r
    elif $l and ($r | not) then
      [[$l],.[1][0]] | right_order
    elif $r and ($l | not) then
      [.[0][0],[$r]] | right_order
    else
      [.[0][0],.[1][0]] | right_order
    end
  end
;

(map(select([.,[[2]]] | right_order)) | length + 1) *
(map(select([.,[[6]]] | right_order)) | length + 2)