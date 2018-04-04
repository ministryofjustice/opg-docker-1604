title 'Files copied'

control 'conf.d' do
  impact 1
  title 'conf.d'
  desc 'conf.d files are correctly on disk'
  describe file('/usr/share/elasticsearch/config/elasticsearch.yml') do
    it { should exist }
  end

  describe file('/usr/share/elasticsearch/config/log4j2.properties') do
    it { should exist }
  end
end
