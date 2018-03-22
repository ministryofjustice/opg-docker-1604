// Example taken from https://jenkins.io/doc/pipeline/examples/#jobs-in-parallel

def githubUserPassCredentialsId = '9fb2f9f6-657a-463c-bc1d-2da04b886e41'

// Our initial list of strings we want to run in parallel
def baseImageList = ['opg-base-1604', 'opg-golang-alpine', 'opg-elasticsearch-shared-data-1604']

def baseDependentImageList = ['opg-nginx-1604', 'opg-jre8-1604', 'opg-kibana-1604', 'opg-wkhtmlpdf-1604', 'opg-ssmtp-1604', 'opg-rabbitmq-1604', 'opg-mongodb-1604']

def nginxDepedentImageList = ['opg-php-fpm-71-ppa-1604','opg-php-fpm-1604','opg-nginx-router-1604' ]
def jreDepedentImageList = ['opg-elasticsearch5-1604', 'opg-jenkins2-1604', 'opg-jenkins-slave-1604' ]
def secondOrderDependentImageList = nginxDepedentImageList + jreDepedentImageList

def thirdOrderDependentImageList = ['opg-phpunit-1604', 'opg-phpcs-1604']


// The map we'll store the parallel steps in before executing them.
def baseImageSteps = baseImageList.collectEntries {
    ["echoing ${it}" : transformIntoStep(it)]
}

def baseDependentImageSteps = baseDependentImageList.collectEntries {
    ["echoing ${it}" : transformIntoStep(it)]
}

def secondOrderDependentImageSteps = secondOrderDependentImageList.collectEntries {
    ["echoing ${it}" : transformIntoStep(it)]
}

def thirdOrderDependentImageSteps = thirdOrderDependentImageList.collectEntries {
    ["echoing ${it}" : transformIntoStep(it)]
}


// Take the string and echo it.
def transformIntoStep(inputString) {
    // We need to wrap what we return in a Groovy closure, or else it's invoked
    // when this method is called, not when we pass it to parallel.
    // To do this, you need to wrap the code below in { }, and either return
    // that explicitly, or use { -> } syntax.
    return {
        stage(inputString){
            script {
                img = docker.build("registry.service.opg.digital/"+inputString, inputString)                
                img.tag(env.NEWTAG) 
                if (env.BRANCH_NAME == "master") {
                    // Only push a latest image if we are processing the master branch.
                    echo "On master branch. Pushing latest image for " + inputString
                    img.push()
                }
                img.push(env.NEWTAG)
            }
        }
    }
}



node("!master")  {

    stage('checkout') {
        checkout scm
    }
    
    stage('create the tag') {
        script {
            if (env.BRANCH_NAME != "master") {
                env.STAGEARG = "--stage ci"
            } else {
                // this can change to `-dev` tags we we switch over.
                env.STAGEARG = "--stage master"
            }
        
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: githubUserPassCredentialsId, usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
                sh '''
                    virtualenv venv
                    . venv/bin/activate
                    pip install git+https://github.com/ministryofjustice/semvertag.git@1.1.0
                    # git config tweak is due to a limitation on the jenkins branch sources (github) plugin
                    git config url."https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/".insteadOf "https://github.com/"

                    git fetch --tags
                    NEWTAG=$(semvertag bump patch $STAGEARG)

                    git tag ${NEWTAG}
                    git push origin ${NEWTAG}
                '''
            }

            env.NEWTAG = readFile('semvertag.txt').trim()
            currentBuild.description = "${NEWTAG}"
        }
        archiveArtifacts artifacts: 'semvertag.txt'
    }
    
    lock('opg-docker-1604-joblock') {
        parallel baseImageSteps
        parallel baseDependentImageSteps
        parallel secondOrderDependentImageSteps
        parallel thirdOrderDependentImageSteps
    }

}
