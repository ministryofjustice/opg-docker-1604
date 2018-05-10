# encoding: utf-8

title 'Commands'

control 'Commands' do
  impact 1
  title 'Git'
  desc 'git is installed and available'
  describe command('git --version') do
    its('stdout') { should match %r{2} }
  end

  impact 1
  title 'Dep'
  desc 'goalgn dep tool is installed'
  describe command('dep version') do
    its('stdout') { should match %r{devel} }
  end
end
