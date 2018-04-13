def make_command() {
  dir(STAGE_NAME){
    sh """
      #!/bin/bash -e
      . /usr/local/share/chruby/chruby.sh;chruby ruby-2.5.0
      . ../tag_functions.sh
      make build
      make test
      tag_and_push_image ${STAGE_NAME}
    """
  }
}



pipeline {
  agent { label "!master" }

  stages {
    stage('Build Environment') {
      parallel {
        stage('Inspec Gem'){
          steps {
            sh """
              #!/bin/bash -e
              . /usr/local/share/chruby/chruby.sh;chruby ruby-2.5.0
              gem install inspec -q --no-document
            """
          }
        }
        stage('Get SemverTag'){
          steps {
            sh '''
              #!/bin/bash
              virtualenv venv
              . venv/bin/activate
              pip install git+https://github.com/ministryofjustice/semvertag.git@1.1.0
            '''
          }
        }
      }
    }

    stage('Build Base Images'){
      parallel {
        stage('opg-base-1604'){ steps { script { make_command() }}}
        stage('opg-elasticsearch-shared-data-1604'){ steps { script { make_command() }}}
        stage('opg-golang-alpine') { steps { script { make_command() }}}
      }
    }

    stage('Nginx Depedent'){
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

    stage('JRE Depedent'){
      parallel{
        stage('opg-elasticsearch5-1604') { steps { script { make_command() }}}
        stage('opg-jenkins2-1604')       { steps { script { make_command() }}}
        stage('opg-jenkins-slave-1604')  { steps { script { make_command() }}}
      }
    }

    stage('PHP-FPM Images'){
      parallel{
        stage('opg-phpunit-1604') { steps { script { make_command() }}}
        stage('opg-phpcs-1604')   { steps { script { make_command() }}}
      }

    }
  }

  post { always { sh "bash cleanup.sh" } }

}
