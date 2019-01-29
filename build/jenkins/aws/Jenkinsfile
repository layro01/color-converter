pipeline {
  agent any
  environment {
    IAST_SERVER_HOST = "agent-server"
    IAST_SERVER_PORT = "10010"
    IAST_AGENT_PATH = "/"
    NODE_PATH = "${IAST_AGENT_PATH}"
  }
  stages {
    stage('Build') { 
      steps {
        sh 'npm install'
        sh 'npm install forever -g'
      }
    }
    stage('Test') {
      steps {
        echo "Running Test stage against Agent Server: ${IAST_SERVER_HOST}:${IAST_SERVER_PORT}"
        script {
          def agentPath = "${NODE_PATH}/agent_nodejs_linux64.node"
          dir("${NODE_PATH}") {
            if (fileExists("agent_nodejs_linux64.node")) {
              echo "Using Agent: ${agentPath}"
            } else {
              echo "ERROR: Agent cannot be found at: ${agentPath}"
            }
          }
        }
        wrap([$class: 'HailstoneBuildWrapper', location: env.IAST_SERVER_HOST, port: env.IAST_SERVER_PORT]) {
          sh "forever start -e err.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c /bin/sh ./start.sh ${env.IAST_SERVER_HOST} ${env.IAST_SERVER_PORT}"
          sleep(time:30,unit:"SECONDS")
          // Comment in this next line to view the Agent log.
          sh 'cat err.log'
          sh 'npm test'
          sh 'forever stop 0'
        }
      }
    }
    stage('Deploy') { 
      steps {
        sh 'echo npm package would run here...'
      }
    }
  }
}