#!/bin/bash

quiet() { ("$@" &>/dev/null &) &>/dev/null; }

cd "$(dirname "$0")"

if [ ! -e ccc.lua ]; then
    cp examples/ccc.0.lua ccc.lua
fi

pid=$(pgrep -a conky | sed -n '/^[0-9]\+\s\+conky -c ccc[.]lua$/ s/ .*//p')

# restart it if running

if [[ -n $pid ]]; then
    kill $pid
fi

quiet conky -c ccc.lua
