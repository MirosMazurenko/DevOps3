#!/bin/bash

LOG_FILE="scriptB.log"

while true;
do
    delay=$((RANDOM % 6 + 5))
    sleep "$delay"
    
    # Отправка HTTP GET запроса с таймаутом 10 секунд
    response=$(curl -s -o /dev/null -w "%{http_code}" -m 10 -i -X GET http://127.0.0.1:80/compute)
    
    # Проверка успешности запроса
    if [ "$response" -ne 200 ]; then
        echo "Failed HTTP request at $(date) with status code $response" >> "$LOG_FILE"
    else
        echo "Sent HTTP request at $(date)" >> "$LOG_FILE"
    fi
done

