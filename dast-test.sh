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
export AGENT_SERVER_URL="https://${IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION}:${IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT}/iast/as/v1"

export DAST_EVENT_CONSUMER_URL=https://iast.malachite.veracode.com/event_consumer

# Ping Veracode Interactive Agent Server to make sure it's alive.
status_code=$(curl --write-out %{http_code} --silent --output /dev/null --insecure ${AGENT_SERVER_URL})
if [[ "$status_code" -ne 200 ]]; then
  echo "ERROR: Veracode Interactive Agent Server not available at ${AGENT_SERVER_URL} (Status code: ${status_code})."
  exit 1
fi;

# Generate a GUID for the scan_stream_id.
UUID=$(uuidgen)
export SCAN_STREAM_ID=$(echo "${UUID}" | tr '[:upper:]' '[:lower:]')

# Create a scan_stream resource for this run.
curl -H "Authorization:123456" -H "Content-Type:application/json" --silent --insecure -X POST -d "{\"data\": {\"scan_stream_id\": \"${SCAN_STREAM_ID}\", \"shared_secret\": \"BRn6zLMmHVnoubgN80A4L9uI4rkQqHuM\", \"session_status\": \"HANDSHAKE\", \"organization_id\": \"7812\", \"type\": \"scan_stream\"}}" ${DAST_EVENT_CONSUMER_URL}/scan_streams
echo Using scan_stream_id: ${SCAN_STREAM_ID}.

# Set the path to pick up the Veracode Interactive Agent.
export NODE_PATH=~/vscode/hailstone/iast-dev/out/agent/Debug/nodejs

# Start the Node Express server with the Veracode Interactive Agent attached.
forever start -e ${SCAN_STREAM_ID}.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c "node -r ./agent_nodejs_${PLATFORM}" app/server.js

# Give the server some time to start.
sleep 10

# Send an X-IAST-Scan-Start header through the application.
# This will set the scan_stream/${SCAN_STREAM_ID} session_status to READY.
curl -H "X-IAST-Scan-Start:${SCAN_STREAM_ID}" http://localhost:3000

# Run the Mocha tests for the started server application.
# (You can think of this as being the 'crawl only' scan...)
npm test

# Send an X-IAST-Scan-Stop header through the application.
# This will set the scan_stream/${SCAN_STREAM_ID} session_status to CLOSED.
curl -H "x-iast-scan-stop:${SCAN_STREAM_ID}" http://localhost:3000

# Stop the Node Express server application
forever stopall

# Print the Veracode Interactive Summary Report to the console.
curl -H "Accept:text/plain" --insecure -X GET ${AGENT_SERVER_URL}/results?session_tag=${SCAN_STREAM_ID}

# Give the report URL for this run (denoted by the SCAN_STREAM_ID).
echo
echo "View the Veracode Interactive Summary Report at this URL: ${AGENT_SERVER_URL}/results?session_tag=${SCAN_STREAM_ID}"
