pipeline {
  agent {
    docker {
      image 'node:10-alpine' 
      args '-p 3000:3000' 
    }
  }
  environment {
    NODE_PATH = '/home/vscode/hailstone/iast-dev/out/agent/nodejs'
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
          sh 'forever start -e server-stderr.log --killTree --minUptime 1000 --spinSleepTime 1000 -c /bin/bash ./start.sh'
          sh 'forever list'
          sh 'cat server-stderr.log'
          sh 'npm test'
          sh 'forever stopall'
        }
      }
    }
  }
}