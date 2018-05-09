# encoding: utf-8

title 'Program Installed'

control 'Services' do
  impact 1
  title 'RabbitMQ service'
  desc 'RabbitMQ service is setup and installed'
  describe runit_service('rabbitmq') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'Environment Variables' do
  impact 1
  title 'Environment Variables'
  desc 'Environment varialbes are setup correctly'
  describe os_env('RABBITMQ_SSL') do
    its('content') { should eq 'true' }
  end
end

# control 'Listening Ports' do
#   impact 0
#   title 'Listening Ports'
#   describe port(5672) do
#     it { should be_listening }
#     its('processes') { should include 'rabbitmq' }
#     its('protocols') { should include 'tcp' }
#   end
#
#   describe port(5671) do
#     it { should_not be_listening }
#   end
# end
