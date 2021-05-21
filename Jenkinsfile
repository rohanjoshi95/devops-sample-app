node {
    withEnv(['terraform=/usr/local/bin/terraform']){
       stage('SCM Checkout') { 
            checkout([$class: 'GitSCM', branches: [[name: '*/stage']],
            userRemoteConfigs: [[credentialsId: 'db49e728-bf73-4961-bb8f-a34924f760b2', 
            url: 'https://github.com/rohanjoshi95/Product.git']]])
       }
        stage ('build package')  {
            sh '''
            mvn clean install
            '''
            build job: 'sonarqube', wait: false
        }
        stage("Build Docker Image"){
            docker.withRegistry('https://registry.hub.docker.com', 'db49e728-bf73-4961-bb8f-a34924f760b2') {
            def customImage = docker.build("rohanjoshi95/product:latest")
            customImage.push()
            }
        }
        stage('Spin up Infrastructure for Staging Environment') {
            sh '''
            cd kube-cluster/
            sudo ${terraform} init
            sudo ${terraform} plan
            sudo ${terraform} apply -auto-approve
            '''
        }
        stage('Spin up Infrastructure for Prod Environment') {
            sh '''
            cd /var/lib/jenkins/workspace/Product/prod_infra/
            sudo ${terraform} init
            sudo ${terraform} plan
            sudo ${terraform} apply -auto-approve
            '''
        }
        stage('Deployment on Staging Environment'){
            sh '''
            cd /var/lib/jenkins/workspace/Product/kube-cluster/
            sudo chmod 400 Mumbai.pem
            sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ./Mumbai.pem -i ./stage_hosts ./deployment.yml
            '''
        }
        stage ('Approval For Production Deployment')  {
            echo "Taking approval from Prod Manager"     
            timeout(time: 10, unit: 'DAYS') {
            input message: 'Deploy into Production after UAT', submitter: 'rohanjoshi95'
            }
         }
          stage('Deployment on Production Environment'){
            sh '''
            cd /var/lib/jenkins/workspace/Product/prod_infra/
            sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /var/lib/jenkins/workspace/Product/kube-cluster/Mumbai.pem -i ./prod_hosts ./deployment.yml
            '''
        }
    }
}
