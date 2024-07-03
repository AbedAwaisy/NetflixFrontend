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
        IMAGE_TAG = "v1.0.${BUILD_NUMBER}"
        IMAGE_BASE_NAME = 'netflix-frontend'
    }

    stages {
        stage('Install yq') {
            steps {
                sh '''
                    if ! command -v yq &> /dev/null
                    then
                        echo "yq could not be found, installing..."
                        curl -L https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_amd64 -o /usr/local/bin/yq
                        chmod +x /usr/local/bin/yq
                    else
                        echo "yq is already installed"
                    fi
                '''
            }
        }

        stage('Docker setup') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            docker login -u $DOCKER_USERNAME -p $DOCKER_PASS
                        '''
                    }
                }
            }
        }

        stage('Build & Push') {
            steps {
                script {
                    env.IMAGE_FULL_NAME = "${DOCKER_USERNAME}/${IMAGE_BASE_NAME}:${IMAGE_TAG}"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            docker build -t $IMAGE_FULL_NAME .
                            docker push $IMAGE_FULL_NAME
                        '''
                    }
                }
            }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'NetflixFrontendDeploy', wait: false, parameters: [
                    string(name: 'SERVICE_NAME', value: "NetflixFrontend"),
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: "${env.IMAGE_FULL_NAME}")
                ]
            }
        }
    }
}
