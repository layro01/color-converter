pipeline {
  agent {
    docker {
      image 'node:9'
    }
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