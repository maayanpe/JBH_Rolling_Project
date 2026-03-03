pipeline {
  agent any

  environment {
    IMAGE_NAME = "maayan35/flask-aws-monitor"
    IMAGE_TAG  = "${env.BUILD_NUMBER}"
  }

  stages {

    stage('Clone Repository') {
      steps {
        checkout scm
      }
    }

    stage('Parallel Checks') {
      parallel {

        stage('Linting') {
          steps {
            sh '''
              echo "MOCK: flake8"
              echo "MOCK: shellcheck"
              echo "MOCK: hadolint"
            '''
          }
        }

        stage('Security Scan') {
          steps {
            sh '''
              echo "MOCK: bandit"
              echo "MOCK: trivy"
            '''
          }
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline completed successfully!'
    }
    failure {
      echo 'Pipeline failed!'
    }
  }
}
