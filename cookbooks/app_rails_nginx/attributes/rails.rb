# Required attributes
set_unless[:rails][:db_app_user] = ""
set_unless[:rails][:db_app_passwd] = ""
set_unless[:rails][:db_schema_name] = ""
set_unless[:rails][:db_dns_name] = ""
set_unless[:rails][:code][:url] = ""

# Optional attributes
set_unless[:rails][:application_name] = "myapp"
set_unless[:rails][:environment] = "production"
set_unless[:rails][:bundler_version] = "1.0.0.beta.8"
set_unless[:rails][:code][:credentials] = ""
set_unless[:rails][:code][:branch] = "master"
set_unless[:rails][:max_pool_size] = "16"
set_unless[:rails][:spawn_method] = "smart-lv2"

# Calculated attributes
set[:rails][:proxy_pass_headers_array] = []
set[:rails][:application_port] = "8000"
set[:rails][:db_adapter] = "mysql"
set[:rails][:code][:destination] = "/home/webapp/#{rails[:application_name]}"
set[:lb_haproxy][:health_check_uri] = "/nginx-health-check-#{rightscale[:instance_uuid]}"

# Platform specific attributes
case platform
when "redhat","centos","fedora","suse"
  set_unless[:rails][:app_user] = "apache"
when "debian","ubuntu"
  set_unless[:rails][:app_user] = "www-data"
else
  set_unless[:rails][:app_user] = "www-data"
end
