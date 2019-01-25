pipeline {
  agent {
    docker {
      image 'node:9'
    }
  }
  parameters {
    string(name: 'IAST_SERVER_HOST', defaultValue: 'localhost', description: 'The Hailstone Agent Server host name.')
    string(name: 'IAST_SERVER_PORT', defaultValue: '10010', description: 'The port that the Hailstone Agent Server is listening to.')
    string(name: 'IAST_AGENT_PATH', defaultValue: '', description: 'The path to the Hailstone Agent (e.g. agent_nodejs_linux64.node).')
  }
  environment {
    NODE_PATH = parms.IAST_AGENT_PATH
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
        echo "Running Test stage with Agent Server: ${params.IAST_SERVER_HOST}:${params.IAST_SERVER_PORT}"
        wrap([$class: 'HailstoneBuildWrapper', location: params.IAST_SERVER_HOST, port: params.IAST_SERVER_PORT]) {
          sh 'export'
          sh 'forever start -e err.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c /bin/sh ./start.sh'
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