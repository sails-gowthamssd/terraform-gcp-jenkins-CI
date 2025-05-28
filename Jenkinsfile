pipeline {
  agent any

  environment {
    GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}\\terraform-sa.json"
    REGION = "us-central1" // ✅ Replace with your Artifact Registry region
    PROJECT_ID = "my-kubernetes-project-456905" // ✅ Replace with your GCP project ID
    REPOSITORY = "hello-world-jenkins-repo" // ✅ Replace with your Artifact Registry repo
    IMAGE_BASE = "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}/hello-world"
    IMAGE_TAG = "build-${BUILD_NUMBER}"
    IMAGE_NAME = "${IMAGE_BASE}:${IMAGE_TAG}"
    IMAGE_LATEST = "${IMAGE_BASE}:latest"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/sails-gowthamssd/terraform-gcp-jenkins-CI.git', branch: 'main'
      }
    }

    stage('Prepare Credentials') {
      steps {
        withCredentials([file(credentialsId: 'TERRAFORM_SA_KEY', variable: 'TF_SA_KEY')]) {
          bat 'copy %TF_SA_KEY% terraform-sa.json'
        }
      }
    }

    stage('Authenticate gcloud & Docker') {
      steps {
        bat 'gcloud auth activate-service-account --key-file=terraform-sa.json'
        bat 'gcloud config set project %PROJECT_ID%'
        bat 'gcloud auth configure-docker %REGION%-docker.pkg.dev --quiet'
      }
    }

    stage('Verify Docker Running') {
      steps {
        bat 'docker version || (echo Docker is not running. Please start Docker Desktop. && exit 1)'
      }
    }

    stage('Build Docker Image') {
      steps {
        bat 'docker build -t %IMAGE_NAME% .'
        bat 'docker tag %IMAGE_NAME% %IMAGE_LATEST%'
      }
    }

    stage('Push Docker Images') {
      steps {
        bat 'docker push %IMAGE_NAME%'
        bat 'docker push %IMAGE_LATEST%'
      }
    }
    stage('Trigger CD') {
      steps {
        build job: 'helloapp-CD', parameters: [
          string(name: 'BUILD_TAG', value: "build-${BUILD_NUMBER}")
        ]
     }
    }
  }
  

  post {
    cleanup {
      bat 'del terraform-sa.json'
    }
  }
}
