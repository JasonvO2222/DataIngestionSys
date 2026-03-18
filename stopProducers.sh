#!/bin/bash

docker exec producer1 rm /tmp/producer_running
docker exec producer2 rm /tmp/producer_running
docker exec producer3 rm /tmp/producer_running