FROM registry.service.opg.digital/opg-jre8-1604

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  apparmor \
  apt-transport-https \
  ca-certificates \
  curl \
  docker-ce \
  fontconfig \
  gettext \
  libexpat1-dev \
  libffi-dev \
  libgmp3-dev \
  libssl-dev \
  libx11-6 \
  libxml2-dev \
  libxslt1-dev \
  libyaml-dev \
  python-dev \
  python2.7-dev \
  python3-dev \
  software-properties-common \
  ttf-dejavu \
  zip && \
  apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/* && \
  pip install -U pip && \
  pip install virtualenv git+https://github.com/ministryofjustice/semvertag.git && \
  curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

### This section is from https://github.com/jenkinsci/docker/blob/master/Dockerfile with changes ###
ENV JENKINS_HOME="/srv/jenkins" \
  JENKINS_UC="https://updates.jenkins.io" \
  JENKINS_SLAVE_AGENT_PORT="50000"\
  JENKINS_VERSION="2.150.2" \
  JENKINS_SHA="fab70f4e209855e0806315cc419e0cbbbf1bd9b31c6f221f7702aa21145040f8"
ENV JENKINS_URL="https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war" \
  COPY_REFERENCE_FILE_LOG="${JENKINS_HOME}/copy_reference_file.log" \
  JAVA_OPTS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dorg.apache.commons.jelly.tags.fmt.timeZone=Europe/London -Duser.timezone=Europe/London -Duser.country=GB -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-same-origin allow-scripts; default-src 'unsafe-inline'; script-src * 'unsafe-inline'; img-src *; style-src * 'unsafe-inline'; font-src *\""

ARG user=app
ARG group=app
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid.
# Add jenkins user to docker group
RUN groupmod -g ${gid} -n ${group} app \
  && usermod -d "${JENKINS_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash -l "${user}" app \
  && adduser "${user}" docker

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY docker/etc/service /etc/sv/

RUN ln -s /etc/sv/jenkins /etc/service \
  && curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - \
  && chown -R "${user}" "${JENKINS_HOME}" /usr/share/jenkins/ref

# Web interface
EXPOSE 8080
# Slave agents
EXPOSE 50000

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

### END ###

# Required minimum plugins. Execute the following code in jenkins script console for the list.
# def plugins = Jenkins.instance.pluginManager.plugins.sort(false)
# plugins.each{
#   plugin ->
#   if (plugins.last() == plugin) {
#     delimiter = ""
#   } else {
#     delimiter = "\\"
#   }
#   println ("${plugin.getShortName()}:${plugin.getVersion()} ${delimiter}")
# }

RUN /usr/local/bin/install-plugins.sh \
  ace-editor:1.1 \
  analysis-core:1.95 \
  ansicolor:0.5.3 \
  ant:1.9 \
  antisamy-markup-formatter:1.5 \
  apache-httpcomponents-client-4-api:4.5.5-3.0 \
  authentication-tokens:1.3 \
  aws-credentials:1.24 \
  aws-java-sdk:1.11.457 \
  blueocean:1.9.0 \
  blueocean-autofavorite:1.2.3 \
  blueocean-bitbucket-pipeline:1.9.0 \
  blueocean-commons:1.10.2 \
  blueocean-config:1.10.2 \
  blueocean-core-js:1.10.2 \
  blueocean-dashboard:1.10.2 \
  blueocean-display-url:2.2.0 \
  blueocean-events:1.9.0 \
  blueocean-git-pipeline:1.9.0 \
  blueocean-github-pipeline:1.9.0 \
  blueocean-i18n:1.10.2 \
  blueocean-jira:1.10.2 \
  blueocean-jwt:1.10.2 \
  blueocean-personalization:1.10.2 \
  blueocean-pipeline-api-impl:1.9.0 \
  blueocean-pipeline-editor:1.9.0 \
  blueocean-pipeline-scm-api:1.10.2 \
  blueocean-rest:1.10.2 \
  blueocean-rest-impl:1.10.2 \
  blueocean-web:1.10.2 \
  bouncycastle-api:2.17 \
  branch-api:2.1.2 \
  checkstyle:4.0.0 \
  cloudbees-bitbucket-branch-source:2.4.1 \
  cloudbees-folder:6.7 \
  clover:4.10.0 \
  command-launcher:1.3 \
  config-file-provider:3.5 \
  confluence-publisher:2.0.3 \
  copyartifact:1.41 \
  credentials:2.1.18 \
  credentials-binding:1.17 \
  custom-tools-plugin:0.6 \
  display-url-api:2.3.0 \
  docker-build-step:2.2 \
  docker-commons:1.13 \
  docker-workflow:1.17 \
  durable-task:1.29 \
  ec2:1.42 \
  envinject:2.1.6 \
  envinject-api:1.5 \
  extended-choice-parameter:0.76 \
  external-monitor-job:1.7 \
  favorite:2.3.2 \
  file-operations:1.7 \
  git:4.0.0-rc \
  git-client:3.0.0-rc \
  git-server:1.7 \
  github:1.29.3 \
  github-api:1.95 \
  github-branch-source:2.4.2 \
  github-oauth:0.29 \
  groovy:2.1 \
  handlebars:1.1.1 \
  handy-uri-templates-2-api:2.1.6-1.0 \
  htmlpublisher:1.18 \
  icon-shim:2.0.3 \
  jackson2-api:2.9.8 \
  javadoc:1.4 \
  jdk-tool:1.2 \
  jenkins-design-language:1.10.2 \
  jira:3.0.5 \
  job-dsl:1.71 \
  jquery:1.12.4-0 \
  jquery-detached:1.2.1 \
  jsch:0.1.55 \
  junit:1.26.1 \
  ldap:1.20 \
  lockable-resources:2.4 \
  mailer:1.23 \
  matrix-auth:2.3 \
  matrix-project:1.13 \
  maven-plugin:3.2 \
  mercurial:2.5 \
  momentjs:1.1.1 \
  node-iterator-api:1.5.0 \
  pam-auth:1.4 \
  pipeline-build-step:2.7 \
  pipeline-graph-analysis:1.9 \
  pipeline-input-step:2.9 \
  pipeline-milestone-step:1.3.1 \
  pipeline-model-api:1.3.4.1 \
  pipeline-model-declarative-agent:1.1.1 \
  pipeline-model-definition:1.3.2 \
  pipeline-model-extensions:1.3.2 \
  pipeline-multibranch-defaults:2.0 \
  pipeline-rest-api:2.10 \
  pipeline-stage-step:2.3 \
  pipeline-stage-tags-metadata:1.3.4.1 \
  pipeline-stage-view:2.10 \
  plain-credentials:1.5 \
  pubsub-light:1.12 \
  purge-build-queue-plugin:1.0 \
  resource-disposer:0.12 \
  role-strategy:2.9.0 \
  scm-api:2.3.0 \
  script-security:1.51 \
  slack:2.15 \
  slave-setup:1.10 \
  sse-gateway:1.17 \
  ssh-agent:1.17 \
  ssh-credentials:1.14 \
  ssh-slaves:1.29.4 \
  structs:1.17 \
  timestamper:1.8.10 \
  token-macro:2.6 \
  variant:1.1 \
  windows-slaves:1.4 \
  workflow-aggregator:2.6 \
  workflow-api:2.33 \
  workflow-basic-steps:2.14 \
  workflow-cps:2.62 \
  workflow-cps-global-lib:2.13 \
  workflow-durable-task-step:2.28 \
  workflow-job:2.25 \
  workflow-multibranch:2.20 \
  workflow-scm-step:2.7 \
  workflow-step-api:2.19 \
  workflow-support:2.22 \
  ws-cleanup:0.37
USER "root"
