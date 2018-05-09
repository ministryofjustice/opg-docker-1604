# encoding: utf-8

title 'Program Installed'

control 'Installed' do
  impact 1
  title 'gunicorn'
  describe command('/usr/local/bin/gunicorn --version') do
    its('exit_status') { should eq 0 }
  end
end

control 'Environment Variables' do
  impact 1
  title 'Environment Variables'
  desc 'Environment varialbes are setup correctly'
  describe os_env('OPG_SERVICE') do
    its('content') { should eq 'wkhtmlpdf' }
  end
end
