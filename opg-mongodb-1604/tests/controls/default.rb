# encoding: utf-8

title 'Program Installed'

control 'MongoDB Repo' do
  impact 1
  title 'Repo Setup'
  desc 'Repository is setup correctly'
  describe apt('http://repo.mongodb.org/apt/ubuntu') do
    it { should exist }
    it { should be_enabled }
  end
end

control 'Services' do
  impact 1
  title 'MongoD service'
  desc 'MongoD service is setup and installed'
  describe runit_service('mongod') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'Backup Ninja' do
  impact 1
  title 'Backup Ninja Logging'
  desc 'Backup ninja logs to a non-default location'
  describe file('/etc/backupninja.conf') do
    its('content') { should match %r{/var/log/backupninja.log} }
  end
end

control 'Environment Variables' do
  impact 1
  title 'Environment Variables'
  desc 'Environment varialbes are setup correctly'
  describe os_env('OPG_SERVICE') do
    its('content') { should eq 'mongodb' }
  end

  describe os_env('MONGODB_VERSION') do
    its('content') { should eq '3.0.15' }
  end
end
