pipeline {
    agent any
    stages {
        stage('Clone the Repository') { 
            steps {
                script {
                    // Clone the repository if it does not exist
                    if (!fileExists('nodejs.orgProject')) {
                        sh 'git clone https://github.com/zyadtarek11/nodejs.orgProject.git'
                    }
                    // Ensure repository is updated
                    dir('nodejs.orgProject') {
                        sh 'git pull origin main'
                    }
                }
            }
        }
        stage('Install Dependencies') { 
            steps {
                dir('nodejs.orgProject') {
                    sh 'npm ci' // npm ci is preferred for CI environments as it installs faster and locks to package-lock.json
                }
            }
        }
        stage('Unit Tests') { 
            steps {
                dir('nodejs.orgProject') {
                    sh 'npm run test'
                }
            }
        }
        stage('Dockerize') { 
            steps {
                // Clone the Docker configuration repo if necessary
                script {
                    if (!fileExists('NodejsProjectWithArgoCD')) {
                        sh 'git clone https://github.com/zyadtarek11/NodejsProjectWithArgoCD.git'
                    }
                    // Ensure repository is updated
                    dir('NodejsProjectWithArgoCD') {
                        sh 'git pull origin main'
                    }
                }
                // Build Docker image
                dir('NodejsProjectWithArgoCD') {
                    sh 'docker build -t zyadtarek/argocd .'
                }
            }
        }
        stage('Push Docker Image') { 
            steps {
                dir('NodejsProjectWithArgoCD') {
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Log in to Docker Hub using credentials
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                        // Push the image
                        sh 'docker push zyadtarek/argocd'
                        // Log out from Docker after pushing
                        sh 'docker logout'
                    }
                }
            }
        }
    }
}
