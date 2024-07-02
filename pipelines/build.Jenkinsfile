// pipelines/build.Jenkinsfile
// check push trigger
pipeline {
    agent {
        label 'general'
    }

    triggers {
        githubPush()   // trigger the pipeline upon push event in github
    }

    options {
        timeout(time: 10, unit: 'MINUTES')  // discard the build after 10 minutes of running
        timestamps()  // display timestamp in console output
    }

    environment {
        // GIT_COMMIT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        // TIMESTAMP = new Date().format("yyyyMMdd-HHmmss")

        IMAGE_TAG = v1.0.$BUILD_NUMBER
        IMAGE_BASE_NAME = 'netflix-frontend'

        DOCKER_USERNAME = credentials('dockerhub').username
        DOCKER_PASS = credentials('dockerhub').password
    }

    stages {
        stage('Docker setup') {
            steps {
                sh '''
                  docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                '''
            }
        }

        stage('Build & Push') {
            steps {
                sh '''
                  IMAGE_FULL_NAME=$DOCKER_USERNAME/$IMAGE_BASE_NAME:$IMAGE_TAG

                  docker build -t $IMAGE_FULL_NAME .
                  docker push $IMAGE_FULL_NAME
                '''
            }
        }
    }
}

