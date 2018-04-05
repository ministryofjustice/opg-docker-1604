# encoding: utf-8

title 'Program Installed'

control 'Elastic Repo' do
  impact 1
  title 'Elastic Repo Setup'
  desc 'Repository is setup correctly'
  describe apt('https://artifacts.elastic.co/packages/5.x/apt') do
    it { should exist }
    it { should be_enabled }
  end
end

control 'Services' do
  impact 1
  title 'Kibana service'
  desc 'Kibana service is setup and installed'
  describe runit_service('kibana') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'Environment Variables' do
  impact 1
  title 'Environment Variables'
  desc 'Environment varialbes are setup correctly'
  describe os_env('OPG_SERVICE') do
    its('content') { should eq 'kibana' }
  end
end
