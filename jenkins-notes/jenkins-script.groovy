pipeline {
    agent any
    environment {
        IMAGE_NAME = 'petclinic-app'
        CONTAINER_NAME = 'petclinic'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/PushkarrajPujari/spring-petclinic.git'
            }
        }
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Run Docker Container') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true
                docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }
    }
}
