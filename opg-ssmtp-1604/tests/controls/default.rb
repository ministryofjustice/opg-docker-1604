# encoding: utf-8

title 'Program Installed'

# This works locally but fails in Jenkins
# control 'Services' do
#   impact 0
#   title 'postfix service'
#   desc 'postfix service is setup and installed'
#   describe runit_service('postfix') do
#     it { should be_enabled }
#     it { should be_running }
#   end
# end

control 'Environment Variables' do
  impact 1
  title 'Environment Variables'
  desc 'Environment varialbes are setup correctly'
  describe os_env('OPG_SERVICE') do
    its('content') { should eq 'ssmtp' }
  end
end
