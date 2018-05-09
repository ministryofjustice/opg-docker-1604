# encoding: utf-8

title 'Program Installed'

control 'Services' do
  impact 0
  title 'nginx service'
  desc 'nginx service is setup and installed'
  describe runit_service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end
end
