pipeline {
    agent any

    environment {
        registry = "859060840886.dkr.ecr.ap-south-1.amazonaws.com/assignment-images"
        imageTag = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ymuralisanthosh/docker-spring-boot.git']])
            }
        }
        stage('Build Artifact') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('build & tag image') {
            steps {
                script {
                    def dockerImage = docker.build("${registry}:${imageTag}")
                    dockerImage.tag('latest')
                }
            }
        }
        stage('Push image') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 859060840886.dkr.ecr.ap-south-1.amazonaws.com"
                    sh "docker tag ${registry}:${imageTag} ${registry}:latest"
                    sh "docker push ${registry}:${imageTag}"
                    sh "docker push ${registry}:latest"
                }
            }
        }
        stage('Debug Path') {
          steps {
            sh "pwd && ls -al"
          }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "aws eks update-kubeconfig --region ap-south-1 --name assignment-eks"
                    sh "cp -r /home/ubuntu/mychart ./"
                    sh "helm upgrade first --install ./mychart --namespace helm-assignment --set image.tag=$BUILD_NUMBER"
                }
            }
        }
    }
}
