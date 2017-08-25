phpunit
=======

Container for running phpunit.

To run and output results to terminal:

```
docker run -i --rm -v $(pwd):/app registry.service.opg.digital/opg-phpunit-1604 'path/to/tests' -c 'path/to/phpunit.xml'
```

To run and output a JUnit compatible report file:

```
docker run -i --rm --user `id -u` -v $(pwd):/app registry.service.opg.digital/opg-phpunit-1604 'path/to/tests' -c 'path/to/phpunit.xml' --log-junit unit_results.xml
```

This command can be run from a Jenkinsfile as part of an automated build. The [Jenkins JUnit plugin](https://wiki.jenkins.io/display/JENKINS/JUnit+Plugin) can be used to display the test results using the following pipeline step:

```
post {
    always {
        junit 'unit_results.xml'
    }
}
``` 

The ``` --user `id -u` ``` option is important here as it makes the current user the owner of the report file. Without this, the owner would be root making the file hard to delete and causing automated build issues.

To run and produce a test coverage HTML report:

```
docker run -i --rm --user `id -u` -v $(pwd):/app registry.service.opg.digital/opg-phpunit-1604 'path/to/tests' -c 'path/to/phpunit.xml' --coverage-html 'path/to/coverage/report/'
```

To run, produce a test coverage HTML report and a Clover XML coverage report:

```
docker run -i --rm --user `id -u` -v $(pwd):/app registry.service.opg.digital/opg-phpunit-1604 'path/to/tests' -c 'path/to/phpunit.xml' --coverage-clover 'path/to/coverage/report/clover.xml' --coverage-html 'path/to/coverage/report/'
```

This command can be run from a Jenkinsfile as part of an automated build. The [Jenkins Clover plugin](https://wiki.jenkins.io/display/JENKINS/Clover+Plugin) can be used to display the coverage report using the following pipeline step:

```
step([
    $class: 'CloverPublisher',
    cloverReportDir: 'path/to/coverage/report',
    cloverReportFileName: 'clover.xml'
])
``` 
