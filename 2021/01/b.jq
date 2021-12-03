#!/usr/bin/env jq --slurp -f
[.[:-2],.[1:-1],.[2:]] | transpose | map(add) |
[.[:-1],.[1:]] | transpose | map((.[1]-.[0]) | select(.>0)) | length