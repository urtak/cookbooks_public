# Raise trouble for required attributes.
raise "missing rails/db_app_user" if "#{node[:rails][:db_app_user]}".empty?
raise "missing rails/db_app_passwd" if "#{node[:rails][:db_app_passwd]}".empty?
raise "missing rails/db_schema_name" if "#{node[:rails][:db_schema_name]}".empty?
raise "missing rails/db_dns_name" if "#{node[:rails][:db_dns_name]}".empty?

template "#{node[:rails][:code][:destination]}/shared/config/database.yml"   do
  source "database.yaml.erb"
end
