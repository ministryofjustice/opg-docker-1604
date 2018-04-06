# encoding: utf-8

title 'Java Installed '

control 'Java' do
  impact 1
  title 'Java'
  desc 'Java installed'
  describe apt('https://download.docker.com/linux/ubuntu') do
    it { should exist }
    it { should be_enabled }
  end
end

control 'Files' do
  impact 1
  title 'confd template'
  desc 'Authorizaed Keys should be on disk'
  describe file('/srv/jenkins/.ssh/authorized_keys') do
    it { should exist }
  end
end