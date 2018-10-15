pipeline {
  agent {
    environment {
      CI = 'true'
    }
    docker {
      image 'node:6-alpine' 
      args '-p 3000:3000' 
    }
  }
  stages {
    stage('Build') { 
      steps {
        sh 'npm install' 
      }
    }
    stage('Test') {
      steps {
        sh 'npm start'
        sh 'npm test'
      }
    }
  }
}