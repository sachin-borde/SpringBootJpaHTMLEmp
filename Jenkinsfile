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
      }
    }

    stage('Build JAR') {
      steps {
        // Builds the Spring Boot JAR using the included Maven wrapper
        sh './mvnw clean package -DskipTests'          // :contentReference[oaicite:6]{index=6}
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // Builds image from Dockerfile in repo root
          dockerImage = docker.build(FULL_IMAGE)       // :contentReference[oaicite:7]{index=7}
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          // Authenticate and push both the build-number tag and 'latest'
          docker.withRegistry('', "${DOCKER_CRED_ID}") {
            dockerImage.push("${IMAGE_TAG}")           // :contentReference[oaicite:8]{index=8}
            dockerImage.push('latest')                 // :contentReference[oaicite:9]{index=9}
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs()  // Clean workspace after each run                        :contentReference[oaicite:10]{index=10}
    }
  }
}
