pipeline {
  agent any

  environment {
    // Add Java home
    JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64" // Update path for your system
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
        // Verify wrapper files exist
        sh 'ls -la .mvn/wrapper/*' 
      }
    }

    stage('Setup Java') {
      steps {
        // Install Java if missing (Ubuntu/Debian)
        sh '''
          sudo apt-get update -y
          sudo apt-get install -y openjdk-17-jdk
        '''
      }
    }

    stage('Build JAR') {
      steps {
        sh './mvnw --version' // Verify Java setup
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
