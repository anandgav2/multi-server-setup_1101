pipeline {

	agent {

            label "${AGENT_NODE}"
	}
	/*
        tools {
                terraform 'Terraform'
	        }

*/
    environment {
		LOG_FILE="/home/abinitio/demo_setup.log"
        CONFIG_FILE="${WORKSPACE}/scripts/ansible/cip_common_setup.yml"
        TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"
        cip_instance_public_ip = ""
	}

    stages {



	    stage('Update inventory file if want to use existing servers')
	    {
		    when {
             	expression {
                    return env.USE_EXISTING_SERVERS == "True"  
                }
            }
            
            steps
		    {
			    script
			    {
                    cip_instance_public_ip = sh(script: "grep 'cip_host:' ${env.INSTALLER_PATH}/cip_setup_automation.yml  | awk '{print \$2}' | sed 's/\"//g'", returnStdout:true);
                    a360_instance_public_ip = sh(script: "grep 'a360_host:' ${env.INSTALLER_PATH}/cip_setup_automation.yml  | awk '{print \$2}' | sed 's/\"//g'", returnStdout:true);
                    cip_key_file = sh(script: "grep 'cip_host_key_file:' ${env.INSTALLER_PATH}/cip_setup_automation.yml  | awk '{print \$2}' | sed 's/\"//g'", returnStdout:true);
                    a360_key_file = sh(script: "grep 'a360_host_key_file:' ${env.INSTALLER_PATH}/cip_setup_automation.yml  | awk '{print \$2}' | sed 's/\"//g'", returnStdout:true);
                    functional_user = sh(script: "grep 'functional_user:' ${env.INSTALLER_PATH}/cip_setup_automation.yml  | awk '{print \$2}' | sed 's/\"//g'", returnStdout:true);
  
	            sh "echo 'cip:\n  hosts:\n    cip-instance:\n      ansible_host: ${cip_instance_public_ip}      ansible_ssh_private_key_file: ${cip_key_file}      ansible_user: ${functional_user}\n    a360-instance:\n      ansible_host: ${a360_instance_public_ip}      ansible_ssh_private_key_file: ${a360_key_file}      ansible_user: ${functional_user}' > ./scripts/terraform/inventory.yml"
                    
                    echo "##### SUMMARY LOG FILE : ${env.LOG_FILE} #########"
                    sh "rm -f ${env.LOG_FILE}"
                    sh "touch ${env.LOG_FILE}"
                    sh "rm -f ${env.CONFIG_FILE}"
                    sh "touch ${env.CONFIG_FILE}"

                    sh "echo SERVER PUBLIC IPs >> ${env.LOG_FILE}" 
                    sh "echo 'cip_instance_public_ip: ${cip_instance_public_ip}' >> ${env.LOG_FILE}"
                    sh "echo 'a360_instance_public_ip: ${a360_instance_public_ip}' >> ${env.LOG_FILE}"

				    sh "echo 'cip_instance_public_ip: ${cip_instance_public_ip}' >> ${env.CONFIG_FILE}"
                    sh "echo 'a360_instance_public_ip: ${a360_instance_public_ip}' >> ${env.CONFIG_FILE}"
			    }
		    }
	    
        }

        stage('Terraform Init & Plan --> Initialize EC2 instance')
        { 
            when {
             	expression {
                    return env.USE_EXISTING_SERVERS == "False"  
                }
            }

            steps 
            { 
                script {
                    def sT = new Date()
                    //def timeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                    def startTime = sT.format(TIME_FORMAT)
                    echo "##### SUMMARY LOG FILE : ${env.LOG_FILE} #########"
                    sh "rm -f ${env.LOG_FILE}"
                    sh "touch ${env.LOG_FILE}"
                    sh "rm -f ${env.CONFIG_FILE}"
                    sh "touch ${env.CONFIG_FILE}"
                    sh "echo ----------- SERVER CREATION STARTED -----------  >> ${env.LOG_FILE}"
                    sh "echo Start Time ::  ${startTime} >> ${env.LOG_FILE}" 
                    sh 'cd "${WORKSPACE}/scripts/terraform" ;pwd;terraform init --lock=false;terraform plan --lock=false;terraform plan'   
                }
                
            }
        }

        stage('Terraform Apply -> Create EC2 Instance') 
        { 
            when {
             	expression {
                    return env.USE_EXISTING_SERVERS == "False"  
                }
            }
            
            steps 
            { 
                script 
                {  
                    dir("${WORKSPACE}/scripts/terraform")
                    {
                        sh 'terraform apply --lock=false -auto-approve' 
                        def eT = new Date()
                        def endTime = eT.format(TIME_FORMAT)
                        sh "echo End Time ::  ${endTime} >> ${env.LOG_FILE}" 
                        sh "echo SERVER PUBLIC IPs >> ${env.LOG_FILE}" 
                        sh "terraform output >> ${env.LOG_FILE}"
                        sh "echo ------- SERVER CREATION SUCCESSFUL ---------- >> ${env.LOG_FILE}"
                        cip_instance_public_ip= sh(script: "terraform output cip_instance_public_ip", returnStdout:true);
                        a360_instance_public_ip= sh(script: "terraform output a360_instance_public_ip", returnStdout:true);
                        sh "echo 'cip_instance_public_ip: ${cip_instance_public_ip}' >> ${env.CONFIG_FILE}"
                        sh "echo 'a360_instance_public_ip: ${a360_instance_public_ip}' >> ${env.CONFIG_FILE}"
                    }
                } 
            }
        }

        stage('Configure Server') 
        { 
            steps  
            { 
                script{
                    def sT = new Date()
                    def startTime = sT.format(TIME_FORMAT)
                    sh "echo ----------- SERVER CONFIGURATION STARTED -----------  >> ${env.LOG_FILE}"
                    sh "echo Start Time ::  ${startTime} >> ${env.LOG_FILE}" 
                    sh 'cd "${WORKSPACE}/scripts/ansible/ServerConfig"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key configure-server.yaml' 
                    def eT = new Date()
                    def endTime = eT.format(TIME_FORMAT)
                    sh "echo End Time ::  ${endTime} >> ${env.LOG_FILE}" 
                    sh "echo ------- SERVER CONFIGURATION SUCCESSFUL ---------- >> ${env.LOG_FILE}"
                }
            }
        }

        stage('Install Co>Operating System') 
        { 
            steps 
            { 
                script{
                    echo""
                    def sT = new Date()
                    def startTime = sT.format(TIME_FORMAT)
                    sh "echo ----------- COOP INSTALLATION STARTED -----------  >> ${env.LOG_FILE}"
                    sh 'cd "${WORKSPACE}/scripts/ansible/Coop"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-coop.yaml' 
                    def eT = new Date()
                    def endTime = eT.format(TIME_FORMAT)
                    sh "echo End Time ::  ${endTime} >> ${env.LOG_FILE}" 
                    sh "echo ------- COOP INSTALLATION SUCCESSFUL ---------- >> ${env.LOG_FILE}"
                }
            }
        }
        
        stage('Install AG') 
        { 
            steps 
            { 
                script{
                    echo""
                    def sT = new Date()
                    def startTime = sT.format(TIME_FORMAT)
                    sh "echo ----------- AG INSTALLATION STARTED -----------  >> ${env.LOG_FILE}"
                    cip_instance_public_ip= "10.226.102.14"
                    a360_instance_public_ip= "10.226.102.13"
                    sh "echo 'ag_host: ${cip_instance_public_ip}' >> ${env.CONFIG_FILE}"
                    sh 'cd "${WORKSPACE}/scripts/ansible/AG"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-AG.yaml' 
                    def eT = new Date()
                    def endTime = eT.format(TIME_FORMAT)
                    sh "echo End Time ::  ${endTime} >> ${env.LOG_FILE}" 
                    sh "echo ------- AG INSTALLATION SUCCESSFUL ---------- >> ${env.LOG_FILE}"
                }
                
            }
        }
        
        stage('Install Cafe') 
        { 
            steps 
            { 
                script{
                    echo""
                    def sT = new Date()
                    def startTime = sT.format(TIME_FORMAT)
                    sh "echo ----------- CAFE INSTALLATION STARTED -----------  >> ${env.LOG_FILE}"
                    cip_instance_public_ip= "10.226.102.14"
                    a360_instance_public_ip= "10.226.102.13"                    
                    sh "echo 'cafe_host: ${cip_instance_public_ip}' >> ${env.CONFIG_FILE}"
                    sh 'cd "${WORKSPACE}/scripts/ansible/Cafe"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-cafe.yaml' 
                    def eT = new Date()
                    def endTime = eT.format(TIME_FORMAT)
                    sh "echo End Time ::  ${endTime} >> ${env.LOG_FILE}" 
                    sh "echo ------- CAFE INSTALLATION SUCCESSFUL ---------- >> ${env.LOG_FILE}"
                }
            }
        
        }

        stage('Install CC') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/CC"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-CC.yaml' 

            }
        }
        
        
        stage('Install CIP') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/CIP"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-cip.yaml' 

            }
        } 
        
	    stage('Seed Data') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/seed-data"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key seed-data.yaml' 

            }
        } 
        
        stage('Install QueryIT') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/QueryIT"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key install-queryit.yaml' 

            }
        }

        stage('Start CIP Subsystems') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/CIP"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key start-cip.yaml' 

            }
        } 
        
        stage('Start CIPUI') 
        { 
            steps 
            { 
                echo""
                sh 'cd "${WORKSPACE}/scripts/ansible/CIPUI"  ; ansible-playbook -i ./../../terraform/inventory.yml --vault-password-file=../vault_key start-cipui.yaml' 

            }
        }
    }
}
