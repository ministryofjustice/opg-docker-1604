def make_command() {
  dir(STAGE_NAME){
    sh """
      #!/bin/bash +x
      . /usr/local/share/chruby/chruby.sh;chruby ruby-2.5.0
      . ../functions.sh
      build
      test
      tag_and_push_image ${STAGE_NAME}
    """
  }
}

pipeline {
  agent { label "!master" }

  environment { CI = "true" }

  stages {
    stage('Build Environment') {
      parallel {
        stage('Inspec Gem'){
          steps {
            sh """
              #!/bin/bash +x
              . /usr/local/share/chruby/chruby.sh;chruby ruby-2.5.0
              gem install inspec -q --no-document
            """
          }
        }
        stage('Tag'){
          steps {
            sh '''
              #!/bin/bash +x
              virtualenv venv
              . venv/bin/activate
              pip install git+https://github.com/ministryofjustice/semvertag.git@1.1.0
              git fetch --tags # Fetch once for subsiquent stages
              # Setup Jenkins SSH User
              git config --global user.email "opgtools@digital.justice.co.uk"
              git config --global user.name "jenkins-moj"
            '''
          }
        }
      } //parallel
    }

    stage('Repository Tag') {
      steps {
        sh '''
        #!/bin/bash +x
        . ./functions.sh
        tag
        read_tag
        '''
      }
    }

    stage('Base'){
      parallel {
        stage('opg-base-1604'){ steps { script { make_command() }}}
        stage('opg-elasticsearch-shared-data-1604'){ steps { script { make_command() }}}
        stage('opg-golang-alpine') { steps { script { make_command() }}}
      }
    }

    stage('Base Dependent'){
      parallel {
        stage('opg-nginx-1604')     { steps { script { make_command() }}}
        stage('opg-jre8-1604')      { steps { script { make_command() }}}
        stage('opg-kibana-1604')    { steps { script { make_command() }}}
        stage('opg-wkhtmlpdf-1604') { steps { script { make_command() }}}
        stage('opg-ssmtp-1604')     { steps { script { make_command() }}}
        stage('opg-rabbitmq-1604')  { steps { script { make_command() }}}
        stage('opg-mongodb-1604')   { steps { script { make_command() }}}
      }
    }

    stage('Nginx or JRE Dependent'){
      parallel {
        stage('opg-php-fpm-71-ppa-1604') { steps { script { make_command() }}}
        stage('opg-php-fpm-1604')        { steps { script { make_command() }}}
        stage('opg-nginx-router-1604')   { steps { script { make_command() }}}
        stage('opg-elasticsearch5-1604') { steps { script { make_command() }}}
        stage('opg-jenkins2-1604')       { steps { script { make_command() }}}
        stage('opg-jenkins-slave-1604')  { steps { script { make_command() }}}
      }
    }

    stage('PHP-FPM Dependent'){
      parallel{
        stage('opg-phpunit-1604') { steps { script { make_command() }}}
        stage('opg-phpcs-1604')   { steps { script { make_command() }}}
      }

    }
  }

  post {
    always { sh "bash cleanup.sh" }
    failure { echo 'I failed :(' }
  }

}
