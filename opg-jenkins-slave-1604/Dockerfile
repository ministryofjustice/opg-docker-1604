FROM registry.service.opg.digital/opg-jre8-1604

COPY docker/. /

ENV JENKINS_HOME="/srv/jenkins" \
    OPG_SERVICE="jenkins-slave"

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list &&\
    apt-get update -qq &&\
    apt-get install -qq -y apparmor \
                          docker-ce \
                          libcurl4-gnutls-dev \
                          libexpat1-dev \
                          gettext \
                          libssl-dev \
                          python2.7-dev \
                          python3-dev \
                          python-dev \
                          libxslt1-dev \
                          libxml2-dev \
                          ttf-dejavu \
                          fontconfig \
                          libyaml-dev \
                          libgmp3-dev \
                          libffi-dev \
                          libssl-dev &&\
    apt-get clean &&\
    apt-get autoremove &&\
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN pip install git+https://github.com/ministryofjustice/semvertag.git virtualenv &&\
    echo "Fixing docker GID to sync with underlying ECS so that the user can access the docker socket" &&\
    groupmod -g 497 docker &&\
    adduser app docker &&\
    usermod -d "${JENKINS_HOME}" -m -s /bin/bash app &&\
    mkdir -p /usr/share/jenkins/ref/{users/opgops,.docker} &&\
    mkdir -p /srv/jenkins/builds  &&\
    mkdir -p /srv/jenkins/.ssh    &&\
    chown app /srv/jenkins/builds &&\
    chown app /srv/jenkins/.ssh   &&\
    chmod 0700 /srv/jenkins/.ssh &&\
    chmod a+x /etc/my_init.d/* &&\
    usermod -p '*' app &&\
    ln -s /dev/stdout /var/log/auth.log

EXPOSE 22
