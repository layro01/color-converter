pipeline {
  agent {
    docker {
      image 'node:9'
    }
  }
  parameters {
    string(name: 'IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION', defaultValue: 'localhost', description: 'The Hailstone Agent Server host name.')
    string(name: 'IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT', defaultValue: '10010', description: 'The Hailstone Agent Server port number.')
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
        echo "${params.IASTAGENT_REMOTE_ENDPOINT_HTTP_LOCATION}"
        echo "${params.IASTAGENT_REMOTE_ENDPOINT_HTTP_PORT}"
        sh 'forever start  -e err.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 app/server.js'
        sleep(time:30,unit:"SECONDS")
        sh 'cat err.log'
        sh 'npm test'
        sh 'forever stop 0'
      }
    }
    stage('Deploy') { 
      steps {
        sh 'echo npm package would run here...'
      }
    }
  }
}