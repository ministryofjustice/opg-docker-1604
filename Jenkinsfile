def make_command() {
  dir(STAGE_NAME){
    sh(script: """
      #!/bin/bash +u
      source /usr/local/share/chruby/chruby.sh;chruby ruby-2.6.0
      source ../functions.sh
      build
      test
      tag_and_push_image ${STAGE_NAME}
    """,
    label: 'Build, test & push')
  }
}

pipeline {
  agent { label '!master' }
  environment { CI = "true" }

  stages {
    stage('Setup Build Environment') {
      parallel {
        stage('Inspec Gem'){
          steps {
            sh(script:"""
              #!/bin/bash
              source /usr/local/share/chruby/chruby.sh;chruby ruby-2.6.0
              gem install inspec -q --no-document
            """,
            label: 'Install Inspec')
          }
        }
        stage('SemverTag'){
          steps {
            sh(script:'''
              #!/bin/bash
              virtualenv venv
              source venv/bin/activate
              pip install git+https://github.com/ministryofjustice/semvertag.git@1.1.0
              git fetch --tags # Fetch once for subsiquent stages
              git config --global user.email "opgtools@digital.justice.co.uk"
              git config --global user.name "jenkins-moj"
            ''',
            label: 'Install semvertag')
          }
        }
      }
    }

    stage('Repository Tag') {
      steps {
        sh(script: '''
          #!/bin/bash
          source ./functions.sh
          tag
          read_tag
        ''',
        label: 'Tag')
      }
    }

    stage('Base'){
      parallel {
        stage('opg-base-1604'){ steps { script { make_command() }}}
        stage('opg-elasticsearch-shared-data-1604'){ steps { script { make_command() }}}
        stage('opg-golang-alpine') { steps { script { make_command() }}}
        stage('opg-elastictrim') { steps { script { make_command() }}}
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
        stage('opg-wordpress-1604')   { steps { script { make_command() }}}
      }
    }
  }

  post {
    always { sh "bash cleanup.sh" }
    failure { echo 'I failed :(' }
  }

}
