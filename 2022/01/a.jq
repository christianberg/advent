#!/usr/bin/env jq -rRsf
.[:-1] | split("\n\n") | map(split("\n") | map(tonumber) | add) | sort | last