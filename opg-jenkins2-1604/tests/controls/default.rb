# encoding: utf-8

title 'Jenkins Installed Correctly'

control 'Docker' do
  impact 1
  title 'Docker Repo'
  desc 'Docker Repo installed'
  describe apt('https://download.docker.com/linux/ubuntu') do
    it { should exist }
    it { should be_enabled }
  end
end

control 'Jenkins' do
  impact 1
  title 'ES'
  desc 'Jenkins service is setup correctly'
  describe runit_service('jenkins') do
    it { should be_installed }
    it { should be_enabled }
  end
end
