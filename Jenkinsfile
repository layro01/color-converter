pipeline {
  agent {
    docker {
      image 'node:9'
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
          sh 'forever start --killSignal SIGTERM --minUptime 1000 --spinSleepTime 1000 -c /bin/sh ./start.sh'
          sleep(time:10,unit:"SECONDS")
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