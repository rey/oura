#!/bin/bash

OURA_RING_API_TOKEN=
OURA_RING_API_URL="https://api.ouraring.com/v2"


function apiRequest() {
  local endpoint="$1"

  API_RESPONSE=$(curl --request GET "${OURA_RING_API_URL}/usercollection/${endpoint}" --header "Authorization: Bearer ${OURA_RING_API_TOKEN}")
  if [[ $? -eq 0 ]]; then
    echo "SUCCESS: Retrieved data for endpoint: ${endpoint}"
  else
    echo "ERROR: Failed to retrieve data for endpoint: ${endpoint}. Check out https://status.ouraring.com"
  fi
}

function steps() {
  apiRequest "daily_activity"
  if [[ $? -eq 0 ]]; then
    echo "INFO: Processing ${FUNCNAME} data..."
    echo "${API_RESPONSE}" | jq --compact-output '.data[] | {day: .day, steps: .steps}' > ${FUNCNAME}.json
  fi
}

function sleep() {
  apiRequest "daily_sleep"
  if [[ $? -eq 0 ]]; then
    echo "INFO: Processing ${FUNCNAME} data..."
    echo "${API_RESPONSE}" | jq --compact-output '.data[] | {day: .day, total_sleep: .contributors.total_sleep}' > ${FUNCNAME}.json
  fi
}

steps
sleep
