#!/bin/bash +x

for i in opg-base-1604 opg-elasticsearch-shared-data-1604 opg-golang-alpine;do
  echo "Testing $i";
  (
    cd $i || return
    make build
    make test | tee -a /tmp/test.log
  )
done

for i in opg-nginx-1604 opg-jre8-1604 opg-kibana-1604 opg-wkhtmlpdf-1604 opg-ssmtp-1604 opg-rabbitmq-1604 opg-mongodb-1604;do
  echo "Testing $i";
  (
    cd $i || return
    make build
    make test | tee -a /tmp/test.log
  )
done

for i in opg-elasticsearch5-1604 opg-jenkins2-1604 opg-jenkins-slave-1604;do
  echo "Testing $i";
  (
    cd $i || return
    make build
    make test | tee -a /tmp/test.log
  )
done

for i in opg-phpunit-1604 opg-phpcs-1604;do
  echo "Testing $i";
  (
    cd $i || return
    make build
    make test | tee -a /tmp/test.log
  )
done

docker system prune -f
docker image prune -f
docker stop "$(docker ps -aq)"
