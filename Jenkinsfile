pipeline {
    agent {label 'worker'}

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
    }
    post {
    always {
        dependencyCheckPublisher(
            pattern: '**/dependency-check-report.xml'
        )
    }
}
}