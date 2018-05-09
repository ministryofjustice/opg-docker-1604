# encoding: utf-8

title 'Program Installed'

control 'phpcs' do
  impact 1
  title 'phpcs'
  desc 'phpcs'
  describe command('/usr/bin/phpcs --version') do
    its('exit_status') { should eq 0 }
  end
end
