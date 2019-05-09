@ECHO OFF
REM You need to copy the following files into this folder before this script will work:
REM    - Make sure the IAST Agent for Windows64 and the associated resource bundle (agent_nodejs_win64.node and iastagent_resources.zip).
REM    - JQ JSON CLI Parser (jq-win64.exe).

REM Configure the Agent to send events to the Agent Server.
SET IASTAGENT_LOGGING_STDERR_LEVEL=info
SET IASTAGENT_REMOTE_ENDPOINT_HTTP_ENABLED=true
SET IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION=localhost
SET IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT=10010
SET AGENT_SERVER_URL=https://%IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION%:%IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT%

REM Set a unique identifier for this run (based on the folder name and timestamp).
FOR %%I IN (.) DO SET CWD=%%~nI%%~xI
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4%%date:~4,2%%date:~7,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
SET dtStamp24=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
IF "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) ELSE (SET dtStamp=%dtStamp24%)
SET BUILD_TAG=%CWD%_%dtStamp%
ECHO Using BUILD_TAG: %BUILD_TAG%

REM Ping Veracode Interactive Agent Server to make sure it's alive.
FOR /f %%i IN ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://localhost:10010') do SET STATUS_CODE=%%i
IF %STATUS_CODE% == 200 GOTO AGENT_SERVER_OK

REM Veracode Interactive Agent Server is not ok - so report an error and bail.
ECHO ERROR: Veracode Interactive Agent Server not available at %AGENT_SERVER_URL% (Status code: %STATUS_CODE%).
exit 1

:AGENT_SERVER_OK

REM Send session_start event to Agent Server and save off the sessionId returned.
curl -H "Content-Type:application/json" -H "x-iast-event:session_start" --silent --insecure -o response.log -X POST -d "{\"BUILD_TAG\":\"%BUILD_TAG%\"}" https://localhost:10010/event

FOR /f %%i IN ('jq-win64 -r ".sessionId" response.log') do SET SESSION_ID=%%i
ECHO Using sessionId: %SESSION_ID%
del response.log

REM Start the Node Express server with the Veracode Interactive Agent attached.
CALL forever start -e %BUILD_TAG%.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c "node -r ./agent_nodejs_win64" app/server.js

REM Give the server some time to start.
TIMEOUT 10

REM Run the Mocha tests for the started server application.
CALL npm test

REM Stop the Node Express server application
CALL forever stop 0

REM Send session_stop event to Agent Server.
curl -H "Content-Type:application/json" -H "x-iast-event:session_stop" -H "x-iast-session-id:%SESSION_ID%" --silent --output /dev/null --insecure -X POST %AGENT_SERVER_URL%/event

REM Print the Veracode Interactive Summary Report to the console.
curl -H "Accept:text/plain" --insecure -X GET %AGENT_SERVER_URL%/result?sessionId=%SESSION_ID%

REM Give the report URL for this run (denoted by the BUILD_TAG).
ECHO .
ECHO View the Veracode Interactive Summary Report at this URL: %AGENT_SERVER_URL%/result?sessionTag=%BUILD_TAG%
