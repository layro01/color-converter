@echo off

REM These should be fine set at their default values.
REM If we want a user to be able to set them, we could update the Jenkins Plugin so 
REM they could be configured as necessary.
set IASTAGENT_LOGGING_STDERR_LEVEL=info
REM set IASTAGENT_LOGGING_FILE_ENABLED=true
REM set IASTAGENT_LOGGING_FILE_PATHNAME=iastdebug.txt
REM set IASTAGENT_LOGGING_FILE_LEVEL=info
REM set IASTAGENT_ANNOTATIONHANDLER_JSONFILE_ENABLED=true
REM set IASTAGENT_ANNOTATIONHANDLER_JSONFILE_PATHNAME=iastoutput.ndjson
REM set IASTAGENT_ANNOTATIONHANDLER_JSONFILE_LEVEL=info
REM set IASTAGENT_REMOTE_ENDPOINT_HTTP_ENABLED=true
REM set IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION=localhost
REM set IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT=10010

node -r "%cd%\agent_nodejs_win64" app\server.js
