pipeline {
    agent any

    environment {
        GIT_URL = 'git@github.com:ertugruloruc/Devops9.git' // GitHub repo URL'si
        GIT_CREDENTIALS = 'Devops9' // SSH anahtarı ile tanımlı credentials ID
        DOCKERHUB_CREDENTIALS = 'devops9_odev' // Docker Hub credentials ID
        DOCKER_IMAGE = 'ertugruloruc/wordpress' // Docker image ismi
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Dev branch'ini checkout yap
                    git branch: 'dev', url: "${GIT_URL}", credentialsId: "${GIT_CREDENTIALS}"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Dockerfile kullanarak Docker image'i build et
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Temel testleri çalıştır
                    dockerImage.inside {
                        // PHP'nin doğru kurulduğunu test et
                        sh 'php -v'
                    }
                }
            }
        }
        
        stage('Merge to Master') {
            when {
                // Sadece dev branch'de çalışacak
                branch 'dev'
            }
            steps {
                script {
                    // Eğer testler başarılı olursa dev branch'ini master ile birleştir
                    sh '''
                    git config --global user.email "ertugruloruc1@gmail.com"
                    git config --global user.name "ertugruloruc"
                    git checkout master
                    git merge dev
                    git push origin master
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            when {
                // Sadece master branch'de Docker Hub'a push edilecek
                branch 'master'
            }
            steps {
                script {
                    // Docker Hub'a image'i push et
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            // Cleanup işlemleri
            script {
                dockerImage.remove()
            }
        }
    }
}
