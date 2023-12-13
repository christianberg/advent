#!/usr/bin/env jq -rRsf
split("\n") |
.[:-1] |
map(
  split(" ") |
  {puzzle: .[0], counts: .[1]} |
  .counts |= (split(",") | map(tonumber))
) |
map(
  .candidates = [{
    remaining_puzzle: .puzzle,
    remaining_counts: .counts,
    in_group: false,
    partial_solution: ""
  }] |
  .solutions = [] |

  until(
    (.candidates | length) == 0;
    .candidates[0] as $cand |
    .candidates |= .[1:] |
    $cand.remaining_puzzle[0:1] as $symbol |
    if $symbol == "." then
      if $cand.in_group then
	if $cand.remaining_counts[0]>0 then
	  .
	else
	  .candidates += [
	    $cand |
	    .partial_solution += $symbol |
	    .remaining_puzzle |= .[1:] |
	    .remaining_counts |= .[1:] |
	    .in_group = false 
	  ]
	end
      else
	.candidates += [
	  $cand |
	  .partial_solution += $symbol |
	  .remaining_puzzle |= .[1:]
	]
      end
    elif $symbol == "?" then
      if $cand.in_group then
	if $cand.remaining_counts[0]>0 then
	  .candidates += [
	    $cand |
	    .partial_solution += "#" |
	    .remaining_puzzle |= .[1:] |
	    .remaining_counts[0] -= 1
	  ]
	else
	  .candidates += [
	    $cand |
	    .partial_solution += "." |
	    .remaining_puzzle |= .[1:] |
	    .remaining_counts |= .[1:] |
	    .in_group = false
	  ]
	end
      else
	.candidates += [
	  $cand |
	  .partial_solution += "." |
	  .remaining_puzzle |= .[1:]
	] |
	if $cand.remaining_counts[0]>0 then
	  .candidates += [
	    $cand |
	    .partial_solution += "#" |
	    .remaining_puzzle |= .[1:] |
	    .remaining_counts[0] -= 1 |
	    .in_group = true
	  ]
	else
	  .
	end
      end
    elif $symbol=="#" then
      if $cand.in_group then
	if $cand.remaining_counts[0]>0 then
	  .candidates += [
	    $cand |
	    .partial_solution += "#" |
	    .remaining_puzzle |= .[1:] |
	    .remaining_counts[0] -= 1
	  ]
	else
	  .
	end
      else
	if $cand.remaining_counts[0]>0 then
	  .candidates += [
	    $cand |
	    .partial_solution += "#" |
	    .remaining_puzzle |= .[1:] |
	    .in_group = true |
	    .remaining_counts[0] -= 1
	  ]
	else
	  .
	end
      end
    else # end of puzzle
      if ($cand.remaining_counts | length)==0 or $cand.remaining_counts==[0] then
	.solutions += [$cand.partial_solution]
      else
	.
      end
    end
  ) |
  .solutions |
  length
) |
add