pipeline {
  agent any

  environment {
    JAVA_HOME       = '/usr/lib/jvm/java-21-openjdk-amd64'
    DOCKER_CRED_ID  = 'dockerhub-creds'
    DOCKER_USER     = 'ssborde26'
    IMAGE_NAME      = "${DOCKER_USER}/springboot-app"
    IMAGE_TAG       = "${env.BUILD_NUMBER}"
    FULL_IMAGE      = "${IMAGE_NAME}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        // Ensure mvnw is Unix-formatted and executable
        sh '''
          sed -i 's/\\r$//' mvnw
          chmod +x mvnw
        '''
      }
    }

    stage('Build JAR') {
      steps {
        // Package Spring Boot app
        sh './mvnw clean package -DskipTests'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // Build using the Docker Pipeline plugin :contentReference[oaicite:4]{index=4}
          dockerImage = docker.build(FULL_IMAGE)
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          // Authenticate and push both tags :contentReference[oaicite:5]{index=5}
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
      // Clean up local images and workspace
      sh 'docker rmi ${FULL_IMAGE} || true'
      cleanWs()
    }
  }
}

