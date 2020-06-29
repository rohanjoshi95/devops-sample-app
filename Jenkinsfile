node {
   stage('Checkout From GitHub') { 
        checkout([$class: 'GitSCM', branches: [[name: '*/stage']],
        userRemoteConfigs: [[credentialsId: '324620ff-3b8a-4c5e-8118-e00aacd80cd0', 
        url: 'https://github.com/rohanjoshi95/Product.git']]])
   }
    stage ('build package')  {
        bat '''
        mvn clean install
        '''
    }
    stage('SonarQube analysis') {
        withSonarQubeEnv('sonarqube') { // If you have configured more than one global server connection, you can specify its name
        bat '''
         mvn clean verify sonar:sonar
        '''
        }
    }
    sleep 150
    stage("Quality Gate"){
        def qualityGate = waitForQualityGate()
            if (qualityGate.status != 'OK') {
                error "Build Job aborted because of quality gate failure: ${lityGate.status}"
            }
    }
    stage("Build Docker Image"){
        docker.withRegistry('https://registry.hub.docker.com', '46786fa6-f4d3-4d3e-b2e8-500df4d6b8ee') {
        def customImage = docker.build("rohanjoshi95/product:latest")
        customImage.push()
        }
    }
    stage('Terraform Init') {
        bat '''
        cd C:/Users/rjoshi4/Documents/Jenkins_Workspace/workspace/JenkinsDemo/kubernetes_infra
        C:/softwares/TERRAFORM/terraform_0.12.26_windows_amd64/terraform init
        '''
    }
    stage('Terraform Plan') {
        bat '''
        cd C:/Users/rjoshi4/Documents/Jenkins_Workspace/workspace/JenkinsDemo/kubernetes_infra
        C:/softwares/TERRAFORM/terraform_0.12.26_windows_amd64/terraform plan
        '''
    }
    stage('Terraform Apply'){
        bat '''
        cd C:/Users/rjoshi4/Documents/Jenkins_Workspace/workspace/JenkinsDemo/kubernetes_infra
        C:/softwares/TERRAFORM/terraform_0.12.26_windows_amd64/terraform apply -auto-approve
        '''
    }
    
}
