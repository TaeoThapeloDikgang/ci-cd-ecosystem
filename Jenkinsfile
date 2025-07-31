pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "taeothapelodikgang/ci-cd-ecosystem-java-app"
        VERSION = "${env.BUILD_ID}" // fallback if APP_TAG is missing
    }

    stages {
        stage('Git Version') {
            steps {
              sh 'git --version'
            }
        }

        stage('Load .env') {
            steps {
                script {
                    def envVars = readFile('.env').trim().split('\n')
                    for (line in envVars) {
                        def (key, value) = line.split('=')
                        if (key == "APP_TAG") {
                            env.APP_TAG = value.trim()
                            env.VERSION = value.trim()  // override VERSION if you want
                            echo "Loaded APP_TAG=${env.APP_TAG}"
                        }
                    }
                }
            }
        }

//         redundant: the build is happening inside the container
//         stage('Build') {
//             steps {
//                 sh './mvnw clean package -DskipTests'
//             }
//         }

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker_hub_credentials') {
                        def app = docker.build("${DOCKER_IMAGE}:${APP_TAG}")
                        app.push()
                    }
                }
            }
        }

        stage('Update Kubernetes YAML') {
            steps {
                script {
                    sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}:${APP_TAG}|' k8s/ci-cd-ecosystem-deployment.yaml"
                }
            }
        }

        stage('Git Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github_creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                      git checkout main
                      git pull origin main
                      git config user.name 'jenkins'
                      git config user.email 'jenkins@example.com'
                      git add .
                      git commit -m "Update image to ${APP_TAG}" || echo "No changes"
                      git remote set-url origin https://$GIT_USER:$GIT_TOKEN@github.com/TaeoThapeloDikgang/ci-cd-ecosystem.git
                      git push origin main
                    '''
                }
            }
        }
    }
}
