#!/bin/bash

IAST_SERVER_HOST=host.docker.internal
IAST_SERVER_PORT=10010
IAST_AGENT_PATH=/home/agents
JENKINS_URL=http://localhost:8080
JENKINS_PROJECT=color-converter

STARTCRUMB=$(curl -s --user "admin:admin" ${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat\(//crumRequestField,%22:%22,//crumb\))

CRUMB="Jenkins-Crumb:${STARTCRUMB:1}"

# curl -s -X POST "${JENKINS_URL}/job/${JENKINS_PROJECT}/build" -H "$CRUMB" --data-urlencode json='{"parameter": [{"IAST_SERVER_HOST":${IAST_SERVER_HOST}, "IAST_SERVER_PORT":"${IAST_SERVER_PORT}", "IAST_AGENT_PATH": "${IAST_AGENT_PATH}"}]}'
curl -s -X POST "${JENKINS_URL}/job/${JENKINS_PROJECT}/build" --data-urlencode json='{"parameter": [{"IAST_SERVER_HOST":${IAST_SERVER_HOST}, "IAST_SERVER_PORT":"${IAST_SERVER_PORT}", "IAST_AGENT_PATH": "${IAST_AGENT_PATH}"}]}'