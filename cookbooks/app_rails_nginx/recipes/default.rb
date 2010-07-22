# Add stub_status to nginx.
# TODO this is nil...
node[:nginx][:configure_flags] << "--with-http_stub_status_module"

# Install passenger/nginx.
include_recipe "passenger_enterprise"
include_recipe "passenger_enterprise::nginx"

# Install mysql client.
include_recipe "mysql::client"

# Install bundler.
ree_gem "bundler" do
  version node[:rails][:bundler_version]
end

# Grab application source from remote repository.
include_recipe "app_rails_nginx::do_update_code"

# Reconfigure existing database.yml, or create from scratch.
include_recipe "app_rails_nginx::setup_db_config"

bash "chown_home" do
  code <<-EOH
    echo "chown -R #{node[:rails][:app_user]}:#{node[:rails][:app_user]} #{node[:rails][:code][:destination]}" >> /tmp/bash
    chown -R #{node[:rails][:app_user]}:#{node[:rails][:app_user]} #{node[:rails][:code][:destination]}
  EOH
end

template "#{node[:nginx][:dir]}/conf.d/app.conf" do
  source "app.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

# Move rails logs to /mnt  (TODO:create move definition in rs_tools?)
rails_log = '/mnt/log/rails'
ruby 'move_rails_log' do
  not_if do File.symlink?('/var/log/rails') end
  code <<-EOH
    `rm -rf /var/log/rails`
    `mkdir -p #{rails_log}`
    `ln -s #{rails_log} /var/log/rails`
  EOH
end

# configure logrotate for rails (TODO: create logrotate definition)
template "/etc/logrotate.d/rails" do
  source "logrotate.conf.erb"
  variables :app_name => "rails"
end
