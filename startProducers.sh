#!/bin/bash

docker exec producer1 touch /tmp/producer_running
docker exec producer2 touch /tmp/producer_running
docker exec producer3 touch /tmp/producer_running