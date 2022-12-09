#!/usr/bin/env jq -Rsf
split("\n")[:-1] |

reduce .[] as $line (
  {path: [], dirs: [{path: ["/"], size: 0}]};
  .cmd = $line |
  if $line == "$ ls" then
    .
  elif $line == "$ cd .." then
    .path |= .[:-1]
  elif ($line | startswith("$ cd")) then
    .path += [($line | split(" "))[2]]
  elif ($line | startswith("dir ")) then
    .path as $path |
    ($line | split(" ")[1]) as $name |
    .dirs += [{path: ($path + [$name]), size: 0}]
    # .filesystem[(.path + [$name]) | join(".")] = 0
    # .path as $path |
    # .filesystem |= setpath($path + [$name]; {_name: $name, _dirsize: 0})
  else
    .path as $path |
    ($line | split(" ")) as $stat |
    ($stat[0] | tonumber) as $size |
    ((.dirs[] | select(.path == $path[:(.path|length)])) | .size) += $size  
    # .filesystem[.path | join(".")] += $size 
    # .filesystem |= setpath($path + [$stat[1]]; $size) |
    # .filesystem |= setpath($path + ["_dirsize"]; getpath($path + ["_dirsize"]) + $size)
  end
) |
.dirs |
(.[] | select(.path==["/"]) | .size) as $totalsize |
map(
  .size |
  select(. >= ($totalsize - (70000000 - 30000000)))
) |
min