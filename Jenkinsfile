pipeline {
    agent {label 'worker'}

    environment{
        SONAR_HOME = tool "sonar"
    }

    stages {
        stage('Clean up') {
            steps {
                cleanWs()
            }
        }
        stage('Code') {
            steps {
                git url:"https://github.com/hetgajera01/wanderlust.git", branch: "main"
            }
        }
        stage("Trivy: Filesystem scan"){
            steps{
                script{
                   sh "trivy fs ."
                }
            }
        }
        stage('owasp: dependency check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    withSonarQubeEnv("Sonar"){
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=wanderlust -Dsonar.projectKey=wanderlust -X"
                    }        
                }
            }
        }
        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_TOKEN'
                )]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }
        stage("Docker: build image"){
            steps{
                script{
                    dir('frontend')
                    {
                        sh """
                            docker build -t hetgajera01/wanderlust-frontend:${BUILD_NUMBER} .
                            docker push hetgajera01/wanderlust-frontend:${BUILD_NUMBER}
                        """
                    }
                    dir('backend')
                    {
                        sh """
                            docker build -t hetgajera01/wanderlust-backend:${BUILD_NUMBER} .
                            docker push hetgajera01/wanderlust-backend:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
        stage('Update Manifest') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {

                    sh """
                        git config user.name "Jenkins"
                        git config user.email "jenkins@example.com"

                        # Update backend image
                        sed -i 's|image: hetgajera01/wanderlust-backend:.*|image: hetgajera01/wanderlust-backend:${BUILD_NUMBER}|g' backend-deployment.yaml

                        # Update frontend image
                        sed -i 's|image: hetgajera01/wanderlust-frontend:.*|image: hetgajera01/wanderlust-frontend:${BUILD_NUMBER}|g' frontend-deployment.yaml

                        git add .

                        git commit -m "Update images to ${BUILD_NUMBER}" || true

                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/hetgajera01/wanderlust-k8s.git HEAD:main
                    """
                }
            }
}
    }
    post {
    always {
        dependencyCheckPublisher(
            pattern: '**/dependency-check-report.xml'
        )
    }
}
}