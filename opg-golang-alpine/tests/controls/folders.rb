# encoding: utf-8

title 'Commands'

control 'Commands' do
  impact 1
  title 'Git'
  desc 'git is installed and available'
  describe command('git --version') do
    its('stdout') { should match %r{2} }
  end
end
