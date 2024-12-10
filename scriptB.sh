#!/bin/bash

while true;
do
    delay=$((RANDOM % 6 + 5))
    sleep "$delay"
    curl -i -X GET 127.0.0.1/compute
    echo "Sent HTTP request at $(date)"
done
