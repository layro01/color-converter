#!/bin/bash

# Set the platform that the script is running on.
case "$OSTYPE" in
  darwin*)
    PLATFORM=darwin64
    ;;
  linux*)
    PLATFORM=linux64
    ;;
  *)
    echo "Unknown operating system. Building on this system is not supported."
    exit 1;
    ;;
esac

# Configure the Agent to send events to the Agent Server.
export IASTAGENT_LOGGING_STDERR_LEVEL=info
export IASTAGENT_REMOTE_ENDPOINT_HTTP_ENABLED=true
export IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION=localhost
export IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT=10010
export AGENT_SERVER_URL="https://${IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION}:${IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT}"

# Set a unique identifier for this run (based on the folder name and timestamp)
export BUILD_TAG=$(basename "$PWD")-$(date +%Y-%m-%d_%H-%M-%S)
echo "Using BUILD_TAG: ${BUILD_TAG}"

# Ping Veracode Interactive Agent Server to make sure it's alive.
status_code=$(curl --write-out %{http_code} --silent --output /dev/null --insecure ${AGENT_SERVER_URL})
if [[ "$status_code" -ne 200 ]]; then
  echo "ERROR: Veracode Interactive Agent Server not available at ${AGENT_SERVER_URL} (Status code: ${status_code})."
  exit 1
fi;

# Send session_start event to Agent Server and save off the sessionId returned.
SESSION_ID=$(curl -H "Content-Type:application/json" -H "x-iast-event:session_start" --silent --insecure -X POST -d "{\"BUILD_TAG\":\"${BUILD_TAG}\"}" ${AGENT_SERVER_URL}/event | jq -r '.sessionId')
echo "Using sessionId: ${SESSION_ID}"

# Get the latest version of the Veracode Interactive Agent.
curl -sSL https://s3.us-east-2.amazonaws.com/app.veracode-iast.io/iast-ci.sh | sh

# Start the Node Express server with the Veracode Interactive Agent attached.
forever start -e ${BUILD_TAG}.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c "node -r ./agent_nodejs_${PLATFORM}" app/server.js

# Give the server some time to start.
sleep 10

# Run the Mocha tests for the started server application.
npm test

# Stop the Node Express server application
forever stop 0

# Send session_stop event to Agent Server.
curl -H "Content-Type:application/json" -H "x-iast-event:session_stop" -H "x-iast-session-id:${SESSION_ID}" --silent --output /dev/null --insecure -X POST ${AGENT_SERVER_URL}/event

# Print the Veracode Interactive Summary Report to the console.
curl -H "Accept:text/plain" --insecure -X GET ${AGENT_SERVER_URL}/result?sessionId=${SESSION_ID}

# Give the report URL for this run (denoted by the BUILD_TAG).
echo
echo "View the Veracode Interactive Summary Report at this URL: ${AGENT_SERVER_URL}/result?sessionTag=${BUILD_TAG}"
