#!/usr/bin/env jq -rRsf
.[:-1] |
split("\n") |
map(
  split("\\s+"; "g") |
  .[1:] |
  add |
  tonumber
) |
.[0] as $time |
.[1] as $record |
{
  lower: (($time/2 - ((($time*$time/4) - $record) | sqrt)) | floor),
  upper: (($time/2 + ((($time*$time/4) - $record) | sqrt)) | floor)
} |
.upper - .lower
