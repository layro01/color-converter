#!/bin/bash

STARTCRUMB=$(curl -s --user "admin:admin" http://localhost:8080/crumbIssuer/api/xml?xpath=concat\(//crumRequestField,%22:%22,//crumb\))

CRUMB="Jenkins-Crumb:${STARTCRUMB:1}"

# curl -s -X POST "http://localhost:8080/job/color-converter/build" -H "$CRUMB" --data-urlencode json='{"parameter": [{"IAST_SERVER_HOST":"docker", "IAST_SERVER_PORT":"10010", "IAST_AGENT_PATH": "~/home/agents"}]}'
curl -s -X POST "http://localhost:8080/job/color-converter/build" --data-urlencode json='{"parameter": [{"IAST_SERVER_HOST":"host.docker.internal", "IAST_SERVER_PORT":"10010", "IAST_AGENT_PATH": "~/home/agents"}]}'