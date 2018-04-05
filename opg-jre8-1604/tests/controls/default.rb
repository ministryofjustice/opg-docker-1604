# encoding: utf-8

title 'Java Installed '

control 'Java' do
  impact 1
  title 'Java'
  desc 'Java installed'
  describe command('java -version') do
    its('stderr') { should match(/java version "1.8/) }
  end
end
