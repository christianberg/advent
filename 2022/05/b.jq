#!/usr/bin/env jq -rRsf
./"\n\n" |
(
  .[0]/"\n" |
  map(./"") |
  transpose |
  map(
    reverse |
    select(first | tonumber?) |
    [.[1:] | map(select(. != " "))]
  ) |
  add
) as $stacks |

(.[1]/"\n")[:-1] |
map(
  ./" " |
  {count: .[1], from: .[3], to: .[5]} | map_values(tonumber) |
  .from -= 1 |
  .to -= 1
) |

reduce .[] as $step (
  $stacks;
  .[$step.to] += .[$step.from][-$step.count:] |
  .[$step.from] |= .[:-$step.count]
) |
map(.[-1]) | join("")