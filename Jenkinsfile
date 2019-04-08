pipeline {
  agent any
  environment {
    NODE_PATH = "/var/jenkins_home"
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
        wrap([$class: 'VeracodeInteractiveBuildWrapper', location: 'docker', port: '10010']) {
          sh "forever start -e agent.log --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c 'node -r ./agent_nodejs_linux64' app/server.js"
          sleep(time:30,unit:"SECONDS")
          // Comment in this next line to view the Agent log.
          sh 'cat agent.log'
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