pipeline {
    agent any

    environment {
        GIT_URL = 'git@github.com:ertugruloruc/Devops9.git'  // GitHub repo URL'si
        GIT_CREDENTIALS = 'Devops9'  // SSH anahtarı ile tanımlı credentials ID
        DOCKERHUB_CREDENTIALS = 'devops9_odev'  // Docker Hub credentials ID
        DOCKER_IMAGE = 'ertugruloruc/wordpress-mysql'  // Docker image ismi (WordPress ve MySQL birlikte)
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // GitHub'dan dev branch'ini checkout yap
                    git branch: 'dev', url: "${GIT_URL}", credentialsId: "${GIT_CREDENTIALS}"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Dockerfile kullanarak WordPress ve MySQL birlikte çalışacak Docker image'ı build et
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Docker container içinde temel testler çalıştırılır
                    dockerImage.inside {
                        // PHP'nin doğru kurulduğunu test et
                        sh 'php -v'
                        
                        // MySQL'in doğru çalışıp çalışmadığını test et (isteğe bağlı)
                        sh '''
                        service mysql start
                        mysql --version
                        '''
                    }
                }
            }
        }
        
        stage('Merge to Master') {
            when {
                // Sadece dev branch'te çalışacak
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
                // Sadece master branch'te Docker Hub'a push edilecek
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
