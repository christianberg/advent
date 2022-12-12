#!/usr/bin/env jq -Rsf
.[:-1] | ./"\n\n" |
map(
  (./"\n") as $input |
  {} |
  .items = ($input[1][18:] | split(", ") | map(tonumber)) |
  .operator = ($input[2][23:24]) |
  .operand = ($input[2][25:]) |
  .divisor = ($input[3][21:] | tonumber) |
  .true = ($input[4][29:] | tonumber) |
  .false = ($input[5][30:] | tonumber) |
  .inspections = 0
) |
(reduce map(.divisor)[] as $i (1; . * $i)) as $divs |
{monkeys: ., current_monkey: 0, round: 0} |
until(
  .round==10000;
  if .current_monkey==(.monkeys|length) then
    .current_monkey = 0 |
    .round += 1
  else
    .monkeys[.current_monkey] as $this |
    if $this.items==[] then
      .current_monkey += 1
    else
      $this.items[0] as $item |
      (if $this.operand=="old" then $item else ($this.operand|tonumber) end) as $operand |
      ((if $this.operator=="+" then $item+$operand else $item*$operand end)%$divs) as $new |
      .monkeys[if $new%$this.divisor==0 then $this.true else $this.false end].items += [$new] |
      .monkeys[.current_monkey].inspections += 1 |
      .monkeys[.current_monkey].items |= .[1:]
    end
  end
) |
.monkeys |
map(.inspections) | sort |
.[-1]*.[-2]
