# encoding: utf-8

title 'Program Installed'

control 'PHPUnit' do
  impact 1
  title 'PHP Unit'
  desc 'PHP Unit'
  describe command('/usr/local/bin/phpunit --version') do
    its('exit_status') { should eq 0 }
  end
end
