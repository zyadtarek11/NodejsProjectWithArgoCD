pipeline {
    agent any 
    stages {
        stage('clone the repo') { 
            steps {
                script {
                    if (!fileExists('nodejs.orgProject')) {
                        sh 'git clone https://github.com/zyadtarek11/nodejs.orgProject.git'
                }
                    dir('nodejs.orgProject') {
                        sh 'git pull origin main'
                    }
                }
            }
        }
        stage('Install the dependencies') { 
            steps {
                    dir('nodejs.orgProject') {
                        sh 'npm ci'
                    }
            }
        }
        stage('Unit Test') { 
            steps {
                    dir('nodejs.orgProject') {
                        sh 'npm run test'
                    }
            }
        }
        stage('Dockrize') { 
            steps {
                sh 'git clone '
            }
        }
        stage('push docker image') { 
            steps {
                // 
            }
        }
    }
}