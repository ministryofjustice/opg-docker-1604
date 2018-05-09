# Building

`make build && make test`

If using authentication, ensure the docker config is correctly configured to support this.

# Testing

Each service/folder has a directory called test that contains

- inspec tests
- docker-compose setup for inspec to run against a service.

Docker-compose is used to start a service so we can run inspec against a running container.
