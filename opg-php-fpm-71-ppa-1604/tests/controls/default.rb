# encoding: utf-8

title 'Program Installed'
control 'Services' do
  impact 1
  title 'PHP-FPM service'
  desc 'PHP-FPM service is setup and installed'
  describe runit_service('php-fpm') do
    it { should be_enabled }
    it { should be_running }
  end
end
