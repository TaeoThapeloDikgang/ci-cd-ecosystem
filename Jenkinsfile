pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "taeothapelodikgang/ci-cd-ecosystem-java-app"
        VERSION = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
              git branch: 'main', url: 'https://github.com/TaeoThapeloDikgang/ci-cd-ecosystem.git'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test Docker Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo "DockerHub user is $USER"'
                    sh 'echo "Password is set (hidden for security)"'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        def app = docker.build("${DOCKER_IMAGE}:${VERSION}")
                        app.push()
                    }
                }
            }
        }

        stage('Update Kubernetes YAML') {
            steps {
                script {
                    sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}:${VERSION}|' k8s/ci-cd-ecosystem-deployment.yaml"
                    sh "git config user.name 'jenkins'"
                    sh "git config user.email 'jenkins@example.com'"
                    sh "git add k8s/ci-cd-ecosystem-deployment.yaml"
                    sh "git commit -m 'Update image to ${VERSION}' || echo 'No changes'"
                    sh "git push origin main"
                }
            }
        }
    }
}
