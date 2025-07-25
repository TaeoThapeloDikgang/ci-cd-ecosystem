pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "taeothapelodikgang/ci-cd-ecosystem-java-app"
        VERSION = "${env.BUILD_ID}"
    }

    stages {

        stage('Git Version') {
            steps {
              sh 'git --version'
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker_hub_credentials') {
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
                }
            }
        }

        stage('Git Push to GitHub') {
          steps {
            withCredentials([usernamePassword(credentialsId: 'github_creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
              sh '''
                git pull origin main
                git config user.name 'jenkins'
                git config user.email 'jenkins@example.com'
                git add k8s/ci-cd-ecosystem-deployment.yaml
                git commit -m 'Update image to ${VERSION}' || echo 'No changes'
                git remote set-url origin https://$GIT_USER:$GIT_TOKEN@github.com/TaeoThapeloDikgang/ci-cd-ecosystem.git
                git push origin main
              '''
            }
          }
        }
    }
}
