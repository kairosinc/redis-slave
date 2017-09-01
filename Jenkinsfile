#!groovy

pipeline {
    agent any 

    environment {
        def gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
      //   def gitBranch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
        def gitUrl = sh(returnStdout: true, script: 'git config remote.origin.url').trim()
    }

    stages {
        stage('Docker Build'){
            steps {
                sh 'GIT_URL=${gitUrl} GIT_BRANCH=${BRANCH_NAME} GIT_COMMIT=${gitCommit} kairos-build.sh'
            }
        }


        stage('Deploy') {
            steps {
                sh 'GIT_URL=${gitUrl} GIT_BRANCH=${BRANCH_NAME} GIT_COMMIT=${gitCommit} kairos-deploy.sh'
            }
         }

        stage('Approval') {
            when {
                branch 'master'
            }
            steps {
                timeout(time:5, unit:'DAYS') {
                    input message: 'Deploy to Production?'
                }
            }
        }

        stage('Deploy to Prod') {
            when {
                branch 'master'
            }
            steps {
                sh 'GIT_URL=${gitUrl} GIT_BRANCH=${BRANCH_NAME} GIT_COMMIT=${gitCommit} kairos-deploy.sh prod'
            }
        }
    }

    post {
        success {
            slackSend  failOnError: true,
                           channel: '#jenkins',
                             color: '#139C8A',
                           message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
        }

        failure {
            slackSend  failOnError: true,
                           channel: '#jenkins',
                             color: '#FF6347',
                           message: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
        }

        unstable {
            slackSend  failOnError: true,
                           channel: '#jenkins',
                             color: '#1175E3',
                           message: "UNSTABLE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
        }
    }

    options {
        // For example, we'd like to make sure we only keep 10 builds at a time, so
        // we don't fill up our storage!
        buildDiscarder(logRotator(numToKeepStr:'10'))

        // And we'd really like to be sure that this build doesn't hang forever, so
        // let's time it out after an hour.
        timeout(time: 60, unit: 'MINUTES')
      }
}
