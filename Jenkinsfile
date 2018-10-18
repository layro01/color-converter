node {
  checkout scm
  wrap([$class: 'HailstoneBuildWrapper', location: 'localhost', port: '10010']) {
    stage('Build') { 
      sh 'npm install'
      sh 'npm install forever -g'
    }
    stage('Start server') {
      sh 'forever start app/server.js'
    }
    stage('Test') {
      sh 'npm test'
    }
    stage('Stop server') {
      sh 'forever stop app/server.js'
    }
  }
}