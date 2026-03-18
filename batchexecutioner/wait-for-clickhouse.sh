#!/bin/sh
# wait-for-clickhouse.sh
until curl -s http://server1:8123/ping; do
  sleep 2
done
exec "$@"