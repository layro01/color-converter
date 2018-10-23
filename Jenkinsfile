pipeline {
  agent {
    docker {
      image 'node:10-alpine' 
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
    stage('Test') {
      steps {
        wrap([$class: 'HailstoneBuildWrapper', location: 'host.docker.internal', port: '10010']) {
          sh 'forever start -c /bin/bash ./start.sh'
          sh 'forever list'
          sh 'npm test'
          sh 'forever stopall'
        }
      }
    }
  }
}