pipeline {
  agent any

  environment {
    JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64" // Verify path with `update-alternatives --config java`
    DOCKER_CRED_ID = 'dockerhub-creds'
    DOCKER_USER = 'ssborde26'
    IMAGE_NAME = "${DOCKER_USER}/springboot-app"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'chmod +x mvnw'
        // Verify Maven Wrapper files
        sh 'ls -la .mvn/wrapper/*'
      }
    }

    stage('Build JAR') {
      steps {
        sh './mvnw --version'
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
      sh 'docker rmi ${FULL_IMAGE} || true'
      cleanWs()
    }
  }
}