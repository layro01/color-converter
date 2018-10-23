pipeline {
  agent {
    docker {
      image 'node:10'
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
          sh 'forever start -a -o out.log -e err.log --killTree --minUptime 1000 --spinSleepTime 1000 -c /bin/sh ./start.sh'
          sh 'forever list'
          sh 'cat out.log'
          sh 'cat err.log'
          sh 'npm test'
          sh 'forever stopall'
        }
      }
    }
  }
}