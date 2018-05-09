FROM registry.service.opg.digital/opg-jre8-1604

COPY docker/. /

ENV JAVA_OPTS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dorg.apache.commons.jelly.tags.fmt.timeZone=Europe/London -Duser.timezone=Europe/London -Duser.country=GB" \
    JENKINS_HOME="/srv/jenkins" \
    JENKINS_SLAVE_AGENT_PORT="50000" \
    JENKINS_VERSION="2.46.2" \
    JENKINS_SHA="aa7f243a4c84d3d6cfb99a218950b8f7b926af7aa2570b0e1707279d464472c7" \
    JENKINS_UC="https://updates.jenkins.io" \
    user="app" \
    group="app" \
    uid="1000" \
    gid="1000"

ENV JENKINS_URL="https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war" \
    COPY_REFERENCE_FILE_LOG="${JENKINS_HOME}/copy_reference_file.log"

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&\
    apt-get update &&\
    apt-get install -y --no-install-recommends \
                      apparmor apt-transport-https ca-certificates curl \
                      docker-ce fontconfig gettext \
                      libcurl4-gnutls-dev libexpat1-dev libffi-dev \
                      libgmp3-dev libssl-dev libx11-6 libxml2-dev \
                      libxslt1-dev libyaml-dev \
                      python-dev python2.7-dev python3-dev \
                      software-properties-common \
                      ttf-dejavu zip &&\
    apt-get clean &&\
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* &&\
    pip install -U pip==9.0.3 &&\
    pip install backports.ssl-match-hostname &&\
    pip install docker-compose virtualenv git+https://github.com/ministryofjustice/semvertag.git

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid.
# Add jenkins user to docker group
RUN groupmod -g ${gid}         \
             -n ${group} app &&\
    usermod -d "${JENKINS_HOME}" \
            -u ${uid}          \
            -g ${gid}          \
            -m                 \
            -s /bin/bash       \
            -l ${user} app   &&\
    adduser ${user} docker

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME ${JENKINS_HOME}

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d &&\
    chmod a+x /etc/sv/jenkins/run &&\
    ln -s /etc/sv/jenkins /etc/service &&\
    curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war &&\
    echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - &&\
    chown -R ${user} "${JENKINS_HOME}" /usr/share/jenkins/ref

EXPOSE 8080
EXPOSE 50000
USER ${user}

# Required minimum plugins
RUN /usr/local/bin/install-plugins.sh \
    ansicolor:0.5.2 \
    github-oauth:0.29 \
    role-strategy:2.7.0 \
    ssh-slaves:1.26 \
    job-dsl:1.68 \
    groovy:2.0

USER root
