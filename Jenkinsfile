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
    }
    post {
    always {
        dependencyCheckPublisher(
            pattern: '**/dependency-check-report.xml'
        )
    }
}
}