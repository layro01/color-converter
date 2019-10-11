#!/bin/sh

# These should be fine set at their default values.
# If we want a user to be able to set them, we could update the Jenkins Plugin so 
# they could be configured as necessary.
export IASTAGENT_LOGGING_STDERR_LEVEL=info
# export IASTAGENT_LOGGING_FILE_ENABLED=true
# export IASTAGENT_LOGGING_FILE_PATHNAME=iastdebug.txt
# export IASTAGENT_LOGGING_FILE_LEVEL=info
# export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_ENABLED=true
# export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_PATHNAME=iastoutput.ndjson
# export IASTAGENT_ANNOTATIONHANDLER_JSONFILE_LEVEL=info
# export IASTAGENT_REMOTE_ENDPOINT_HTTP_ENABLED=true
# export IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION=localhost
# export IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT=10010

# You should not need to set a build tag before starting the app with the IAST agent attached.
# export BUILD_TAG=dummy

# curl -sSL https://s3.us-east-2.amazonaws.com/app.veracode-iast.io/iast-ci.sh | sh

# export LD_LIBRARY_PATH=$PWD
node -r ./agent_linux64.node app/server.js
# strace node -r ./agent_linux64 app/server.js 1>startup.strace.log 2>&1
