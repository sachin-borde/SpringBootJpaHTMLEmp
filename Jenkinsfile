pipeline {
  agent any

  environment {
    DOCKER_CRED_ID    = 'dockerhub-creds'
    DOCKER_USER       = 'ssborde26'
    IMAGE_NAME        = "${DOCKER_USER}/springboot-app"
    IMAGE_TAG         = "${env.BUILD_NUMBER}"
    FULL_IMAGE        = "${IMAGE_NAME}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        // Fix permissions for mvnw
        sh 'chmod +x mvnw' 
      }
    }

    stage('Build JAR') {
      steps {
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build(FULL_IMAGE)
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('', "${DOCKER_CRED_ID}") {
            dockerImage.push("${IMAGE_TAG}")
            dockerImage.push('latest')
          }
        }
      }
    }
  }

  post {
    always {
      // Optional: Add Docker cleanup
      sh 'docker rmi ${FULL_IMAGE} || true'
      cleanWs()
    }
  }
}
