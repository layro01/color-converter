pipeline {
  agent any
  environment {
    NODE_PATH = '/usr/local/bin/node'
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
        wrap([$class: 'HailstoneBuildWrapper', location: 'docker', port: '10010']) {
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