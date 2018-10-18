pipeline {
  agent {
    docker {
      image 'node:6-alpine' 
      args '-p 3000:3000' 
    }
  }
  environment {
    CI = 'true'
  }
  stages {
    stage('Build') { 
      steps {
        sh 'npm install'
        sh 'npm install forever -g'
      }
    }
    stage('Start server') {
      steps {
        sh 'forever start app/server.js'
      }
    }
    stage('Test') {
      steps {
        sh 'npm test'
      }
    }
    stage('Stop server') {
      steps {
        sh 'forever stop app/server.js'
      }
    }
  }
}