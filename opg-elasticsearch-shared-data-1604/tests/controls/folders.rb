# encoding: utf-8

title 'Folders copied'

control 'Elastic Folders' do
  impact 1
  title 'Elastic'
  desc 'Folder Copied'
  describe directory('/tmp/elasticsearchshareddata/beats/index-pattern') do
    it { should exist }
  end

  describe directory('/tmp/elasticsearchshareddata/beats/search') do
    it { should exist }
  end

  describe directory('/tmp/elasticsearchshareddata/beats/visualization') do
    it { should exist }
  end

end
