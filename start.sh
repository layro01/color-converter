#!/bin/bash

# To run with forever daemon do the following:
# npm install forever -g
# forever start --killTree --minUptime 1000 --spinSleepTime 1000 -c /bin/bash ./start.sh

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

# Currently using the Hailstone Agent from the host machine dev environment.
# What would be a better way of getting the Agent either into the image or referenced from the host machine?
# export NODE_PATH=~/home/vscode/hailstone/iast-dev/out/agent/nodejs

# These should be configured as necessary in the Jenkins environment.
export IASTAGENT_LOGGING_STDERR_LEVEL=info
export IASTAGENT_LOGGING_FILE_ENABLED=true
export IASTAGENT_LOGGING_FILE_PATHNAME=iastdebug.txt
export IASTAGENT_LOGGING_FILE_LEVEL=info
export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_ENABLED=true
export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_PATHNAME=iastoutput.ndjson
export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_LEVEL=info

# This should (needs to) come from the Jenkins environment.
# Ennable the following line if you want to run the script manually and mock a Jenkins build execution.
# export BUILD_TAG=jenkins-agent-server-test-pipeline-9000

echo Launching with agent: ${NODE_PATH}/agent_nodejs_${PLATFORM}
node -r agent_nodejs_${PLATFORM} app/server.js
