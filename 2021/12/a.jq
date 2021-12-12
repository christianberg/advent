#!/usr/bin/env jq --slurp --raw-input -f

split("\n") | .[:-1] |
map(split("-")) |
(reduce .[] as $i ({};
  .[$i[0]] += [$i[1]] |
  .[$i[1]] += [$i[0]]
)) as $map |

def find_paths:
  if (.candidates | length)==0 then
    .paths
  else
    .candidates[0] as $cand |
    .candidates |= .[1:] |
    if $cand[0]=="end" then
      .paths += [$cand]
    else
      ($map[$cand[0]] | map(select((.==(.|ascii_upcase)) or ([.] | inside($cand) | not)))) as $nexts |
      .candidates |= ($nexts | map([.]+$cand)) + .
    end |
    find_paths
  end
;

{candidates: [["start"]], paths: []} |
find_paths |
length