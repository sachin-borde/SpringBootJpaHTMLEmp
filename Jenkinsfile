pipeline {
  agent any

  environment {
    JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
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
        sh '''
          sed -i 's/\r$//' mvnw
          chmod +x mvnw
          ls -la .mvn/wrapper/maven-wrapper.jar
        '''
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
          docker.build(FULL_IMAGE)
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('', "${DOCKER_CRED_ID}") {
            docker.image(FULL_IMAGE).push()
            docker.image(FULL_IMAGE).push('latest')
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
