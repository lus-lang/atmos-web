#!/bin/sh
# Compares the bare network.serve server of tests/bench/compare with the same
# server on the web package. Runs alternate between the two servers.
# Usage: run.sh LUS [duration] [rounds]
# BARE names the bare server, by default the one of tests/bench/compare in a
# Lus checkout four directories up. In this repository alone, set
# BARE=/path/to/lus/tests/bench/compare/http/server.lus.
LUS=$1
DUR=${2:-10s}
ROUNDS=${3:-3}
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../../.." && pwd)
BARE=${BARE:-$ROOT/tests/bench/compare/http/server.lus}
OUT=${TMPDIR:-/tmp}
for round in $(seq 1 "$ROUNDS"); do
for name in bare web; do
    if [ $name = bare ]; then script=$BARE; port=18101; else script=$HERE/server_web.lus; port=18102; fi
    "$LUS" "$script" $port &
    pid=$!
    sleep 0.5
    curl -s "http://127.0.0.1:$port/" > /dev/null
    idle=$(ps -o rss= -p $pid)
    oha -z 2s -c 64 --no-tui "http://127.0.0.1:$port/" > /dev/null
    ( peak=0; while kill -0 $pid 2>/dev/null; do r=$(ps -o rss= -p $pid 2>/dev/null || echo 0); [ "${r:-0}" -gt "$peak" ] && peak=$r && echo $peak > "$OUT/$name.peak"; sleep 0.1; done ) &
    sampler=$!
    oha -z "$DUR" -c 64 --no-tui --output-format json "http://127.0.0.1:$port/" > "$OUT/$name.json"
    kill $pid 2>/dev/null; wait $pid 2>/dev/null; wait $sampler 2>/dev/null
    rps=$(node -e "const r=require('$OUT/$name.json');console.log(r.summary.requestsPerSec.toFixed(0)+' req/s', (r.latencyPercentiles.p99*1000).toFixed(2)+' ms p99', 'success', r.summary.successRate)")
    echo "$name  $rps  idle $((idle/1024)) MB  peak $(( $(cat "$OUT/$name.peak") / 1024)) MB"
done
done
