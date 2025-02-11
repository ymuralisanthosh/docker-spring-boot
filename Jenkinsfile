pipeline {
    agent any
    
    environment {
        registry = "585008055705.dkr.ecr.ap-south-1.amazonaws.com/my-docker-repo"
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
                    sh "aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 585008055705.dkr.ecr.ap-south-1.amazonaws.com"
                    sh "docker tag ${registry}:${imageTag} ${registry}:latest"
                    sh "docker push ${registry}:${imageTag}"
                    sh "docker push ${registry}:latest"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "aws eks update-kubeconfig --region ap-south-1 --name demo-eks"
                    sh "helm upgrade first --install mychart --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
                }
            }
        }
    }
}
