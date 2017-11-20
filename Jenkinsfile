pipeline {
    
    agent { label "!master"} //run on slaves only
    
    environment {
        DOCKER_REGISTRY = 'registry.service.opg.digital'
    }
    
    stages {
        
        stage('create the tag') {
            steps {
                script {
                    if (env.BRANCH_NAME != "master") {
                        env.STAGEARG = "--stage ci"
                    } else {
                        // this can change to `-dev` tags we we switch over.
                        env.STAGEARG = "--stage master"
                    }
                }
                script {
                    sh '''
                        virtualenv venv
                        . venv/bin/activate
                        pip install git+https://github.com/ministryofjustice/semvertag.git@1.1.0
                        git fetch --tags
                        semvertag bump patch $STAGEARG >> semvertag.txt
                        NEWTAG=$(cat semvertag.txt); semvertag tag ${NEWTAG}
                    '''
                    env.NEWTAG = readFile('semvertag.txt').trim()
                    currentBuild.description = "${NEWTAG}"
                }
                archiveArtifacts artifacts: 'semvertag.txt'
            }
        }
        
        
        stage('base images') {
            parallel {
                stage('opg-base-1604') {
                    steps {
                        script {
                            img = docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}", "${env.STAGE_NAME}").tag("${env.NEWTAG}").push()
                            img.push("${env.NEWTAG}")
                        }
                    }
                }
                // stage('opg-golang-alpine') {
                //     steps {
                //         script {
                //             docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
                //         }
                //     }
                // }
                // stage('opg-elasticsearch-shared-data-1604') {
                //     steps {
                //         script {
                //             docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
                //         }
                //     }
                // }
            }
        }  
          
        
        // stage('base dependent images') {    
        //     parallel {
        //         stage('opg-nginx-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         stage('opg-jre8-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         stage('opg-kibana-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }  
        //         stage('opg-wkhtmlpdf-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }     
        //         stage('opg-ssmtp-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }     
        //         stage('opg-rabbitmq-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         } 
        //         stage('opg-mongodb-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         } 
        //     }
        // }        
        // 
        // stage('2nd order dependent images') {
        //     parallel {
        //         // Depends on nginx 
        //         stage('opg-php-fpm-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         stage('opg-nginx-router-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         // Depends on jre8
        //         stage('opg-elasticsearch5-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         stage('opg-jenkins2-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }
        //         stage('opg-jenkins-slave-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }                  
        //     }
        // }             
        // 
        // stage('3rd order dependent images') {
        //     parallel {
        //         // Depends on phpfpm
        //         stage('opg-phpunit-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }                
        //         stage('opg-phpcs-1604') {
        //             steps {
        //                 script {
        //                     docker.build("${env.DOCKER_REGISTRY}/${env.STAGE_NAME}:${env.NEWTAG}", "${env.STAGE_NAME}").push()
        //                 }
        //             }
        //         }                   
        //     }
        // }     

    }

}