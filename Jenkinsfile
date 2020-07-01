node {
   stage('Checkout From GitHub') { 
        checkout([$class: 'GitSCM', branches: [[name: '*/stage']],
        userRemoteConfigs: [[credentialsId: 'db49e728-bf73-4961-bb8f-a34924f760b2', 
        url: 'https://github.com/rohanjoshi95/Product.git']]])
   }
    stage ('build package')  {
        sh '''
        mvn clean install
        '''
    }
    stage('SonarQube analysis') {
        withSonarQubeEnv('sonarqube') { // If you have configured more than one global server connection, you can specify its name
        sh '''
         mvn clean verify sonar:sonar
        '''
        }
    }
    sleep 30
    stage("Quality Gate"){
        def qualityGate = waitForQualityGate()
            if (qualityGate.status != 'OK') {
                error "Build Job aborted because of quality gate failure: ${qualityGate.status}"
            }
    }
    stage("Build Docker Image"){
        docker.withRegistry('https://registry.hub.docker.com', 'db49e728-bf73-4961-bb8f-a34924f760b2') {
        def customImage = docker.build("rohanjoshi95/product:latest")
        customImage.push()
        }
    }
    stage('Terraform Init') {
        sh '''
        cd kube-cluster/
        sudo /usr/local/bin/terraform init
        '''
    }
    stage('Terraform Plan') {
        sh '''
        cd kube-cluster/
        sudo /usr/local/bin/terraform plan
        '''
    }
    stage('Terraform Apply to setup kubernetes cluster'){
        sh '''
        cd kube-cluster/
        sudo chmod 400 Mumbai.pem
        sudo /usr/local/bin/terraform apply -auto-approve
        '''
    }
}
