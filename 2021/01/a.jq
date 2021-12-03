#!/usr/bin/env jq --slurp -f
[.[:-1],.[1:]] | transpose | map((.[1]-.[0]) | select(.>0)) | length