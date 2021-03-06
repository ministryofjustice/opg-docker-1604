# encoding: utf-8

title 'Program Installed'

control 'Services' do
  impact 1
  title 'nginx service'
  desc 'nginx service is setup and installed'
  describe runit_service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
end

# Test is performed from within the Container
# so that we don't need to port forward or try and avoid port conflicts.
# This is acceptable in this case as we're testing Nginx not the docker-compose
# setup.
control 'Nginx Configured Correctly' do
  impact 1
  title 'Nginx Configured'
  desc 'Nginx should be configured correctly'
  describe http('https://localhost', ssl_verify: false, headers: { 'Host' => 'appservername' }) do
    its('status') { should cmp 200 }
    its('body') { should match 'Hello World from opguk/nginx' }
    its('headers.Content-Type') { should cmp 'text/html' }
    its('headers.X-Request-Id') { exist }
  end
end
