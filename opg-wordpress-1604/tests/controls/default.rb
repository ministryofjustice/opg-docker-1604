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
  title 'nginx POST size'
  desc 'Ensure nginx POST size is 64M'
  describe command('grep -ir client_max_body_size /etc/nginx/conf.d/app.conf') do
    its('stdout') { should match %r{64M} }
  end

  impact 1
  title 'Wordpress can be embedded'
  desc 'Ensure Wordpress can be embedded via Frame Options'
  describe command('grep -ir X-Frame-Options /etc/nginx/conf.d/app.conf') do
    its('stdout') { should match %r{live.sirius-opg.uk} }
  end

  impact 1
  title 'Nginx Configured'
  desc 'Nginx should be configured correctly'
  describe http('https://localhost/', ssl_verify: false) do
    its('status') { should cmp 302 }
    its('headers.Location') { should cmp 'https://localhost/wp-admin/install.php' }
    its('headers.Content-Type') { should cmp 'text/html; charset=UTF-8' }
  end

  impact 1
  title 'Wordpress running'
  desc 'Wordpress running'
  describe http('https://localhost/wp-admin/install.php', ssl_verify: false) do
    its('status') { should cmp 200 }
    its('headers.Content-Type') { should cmp 'text/html; charset=UTF-8' }
    its('body') { should match '<title>WordPress &rsaquo; Installation</title>' }
  end

end
