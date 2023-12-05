#!/usr/bin/env jq -rRsf
.[:-1] |
split("\n\n") |
map(
  split("\n")
) |
(
  .[1:] |
  map(
    .[1:] |
    map(
      split(" ") |
      map(tonumber) |
      {from: .[1], upto: (.[1]+.[2]), shift: (.[0]-.[1])}
    ) |
    sort_by(.from)
  )
) as $mappings |
(.[0][0] | split(" ")[1:] | map(tonumber)) |
{in: ., spans: []} |
until(
  (.in | length) == 0;
  .spans += [{from: .in[0], upto: (.in[0] + .in[1])}] |
  .in |= .[2:]
) |
{spans: (.spans | sort_by(.from)), mappings: $mappings, newspans: []} |
until(
  (.mappings | length) == 0;
  if (.spans | length) == 0 then
    .spans = (.newspans | sort_by(.from)) |
    .newspans = [] |
    .mappings |= .[1:]
  elif (.mappings[0] | length) == 0 then
    .newspans += .spans |
    .spans = []
  elif (.spans[0].upto <= .mappings[0][0].from) then
    .newspans += [.spans[0]] |
    .spans |= .[1:]
  elif ((.spans[0].from < .mappings[0][0].from) and (.spans[0].upto > .mappings[0][0].from)) then
    .newspans += [{from: .spans[0].from, upto: .mappings[0][0].from}] |
    .spans[0].from = .mappings[0][0].from
  elif ((.spans[0].from < .mappings[0][0].upto) and (.spans[0].upto <= .mappings[0][0].upto)) then
    .newspans += [{from: (.spans[0].from + .mappings[0][0].shift), upto: (.spans[0].upto + .mappings[0][0].shift)}] |
    .spans |= .[1:]
  elif ((.spans[0].from < .mappings[0][0].upto) and (.spans[0].upto > .mappings[0][0].upto)) then
    .newspans += [{from: (.spans[0].from + .mappings[0][0].shift), upto: (.mappings[0][0].upto + .mappings[0][0].shift)}] |
    .spans[0].from = .mappings[0][0].upto
  elif (.spans[0].from >= .mappings[0][0].upto) then
    .mappings[0] |= .[1:]
  else
    error("Shouldn't reach here")
  end
) |
.spans |
map(.from) |
min
