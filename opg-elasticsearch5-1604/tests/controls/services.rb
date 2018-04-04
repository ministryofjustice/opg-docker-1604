title 'Services Enabled'

control 'ElasticSearch' do
  impact 1
  title 'ES'
  desc 'ElasticSearch is setup correctly'
  describe runit_service('elasticsearch') do
    it { should be_installed }
    it { should be_enabled }
  end
end
