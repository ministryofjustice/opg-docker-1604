PHP_CodeSniffer
=======

Container for running PHP_CodeSniffer (phpcs).

To run and output results to terminal:

```
docker run -i --rm -v $(pwd):/app registry.service.opg.digital/opg-phpcs-1604 --standard=PSR2 'path/to/src/'
```

To run outputting a checkstyle xml results file:

```
docker run -i --rm --user `id -u` -v $(pwd):/app registry.service.opg.digital/opg-phpcs-1604 --standard=PSR2 --report=checkstyle --report-file=checkstyle.xml 'path/to/src/'
```

This command can be run from a Jenkinsfile as part of an automated build. The ``` --user `id -u` ``` option is important here as it makes the current user the owner of the checkstyle.xml file. Without this, the owner would be root making the file hard to delete and breaking subsequent builds.

The options ``` --runtime-set ignore_warnings_on_exit true --runtime-set ignore_errors_on_exit true ``` are also useful for automated builds if your code is in poor PSR2 shape. It will prevent the PSR2 errors and warnings breaking the build but will still produce a report so you can fix them later.

The [Jenkins Checkstyle plugin](https://wiki.jenkins.io/display/JENKINS/Checkstyle+Plugin) can be used to display the report using the following pipeline step:

```
post {
    always {
        checkstyle pattern: 'checkstyle.xml'
    }
}
```  