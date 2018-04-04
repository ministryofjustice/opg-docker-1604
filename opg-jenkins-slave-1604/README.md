# OPG Jenkins Slave docker image

Exposes port 22 for ssh, only allows key based authentication from jenkins as the app user

## Dockerfile Environment Variables

```
JENKINS_MASTER_AUTHKEYS - *Required* Public key for jenkins to ssh into the system
JENKINS_GITHUB_USERNAME - Github username for commits
JENKINS_GITHUB_EMAIL - Github email for commits
JENKINS_MASTER_URL - required for self registration
JENKINS_AUTH_TOKEN - required for authorisation for the build
JENKINS_JOB_NAME - jenkins job name
```

## Optional Dockerfile Environment Variables

```
SLAVE_HOST_IP - the ip of the slave's host
SLAVE_PROJECT_NAME - the name of the project, used to name the slave
SLAVE_STACK_NAME - the name of the stack, used to name the slave
SLAVE_LABELS - labels to attach to the slave, if stack and project are defined, they will be added as seperate labels
JENKINS_MASTER_PORT - the port we're connecting to via http/https, if non standard
```

## Example

see `docker-compose.yml`

# Additional Notes

Jenkins is run with user `app`, uid = 1000 If you bind mount a volume from the host or a data container, ensure you use the same uid

`/usr/share/jenkins/ref/` contains all reference configuration we want to set on a fresh new installation. Use it to bundle additional plugins or config file with your custom jenkins Docker image.
