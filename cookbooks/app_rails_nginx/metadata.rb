maintainer       "Aaron Gibralter"
maintainer_email "aaron@urtak.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Installs the rails application server with nginx+passenger"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.markdown'))
version          "0.0.1"

depends "passenger_enterprise"
depends "mysql::client"
depends "repo_git"
depends "db_mysql"

depends "resource:repo['default']"

recipe "app_rails_nginx::default", "Installs the rails application server essentials."
recipe "app_rails_nginx::do_update_code", "Update application source files from the remote repository."
recipe "app_rails_nginx::setup_db_config", "Configures the rails database.yml file."

grouping "rails", {
  :display_name => "Rails Settings",
  :description => "Settings for the backend rails app."
}

# required attributes
attribute "rails/db_app_user", {
  :display_name => "Database User",
  :description => "The database user the rails application should use.",
  :required => true,
  :recipes => ["app_rails_nginx::default", "app_rails_nginx::setup_db_config"]
}

attribute "rails/db_app_passwd", {
  :display_name => "Database Password",
  :description => "The database password the rails application should use.",
  :required => true,
  :recipes => ["app_rails_nginx::default", "app_rails_nginx::setup_db_config"]
}

attribute "rails/db_schema_name", {
  :display_name => "Database Schema Name",
  :description => "The database the rails application should use.",
  :required => true,
  :recipes => ["app_rails_nginx::default", "app_rails_nginx::setup_db_config"]
}

attribute "rails/db_dns_name", {
  :display_name => "Database DNS Name",
  :description => "The fully qualified domain name of the database server to which the application server(s) will connect.",
  :required => true,
  :recipes => ["app_rails_nginx::default", "app_rails_nginx::setup_db_config"]
}

# optional attributes
attribute "rails/application_name", {
  :display_name => "Application Name",
  :description => "Sets the directory for your application's web files. E.g. `myapp` => /home/webapps/myapp/current/.",
  :default => "myapp",
  :recipes => ["app_rails_nginx::default", "app_rails_nginx::do_update_code"]
}

attribute "rails/environment", {
  :display_name => "Rails Environment",
  :description => "The Rails Environment of the current workspace. E.g. `production`.",
  :default => "production",
  :recipes => ["app_rails_nginx::default"]
}

attribute "rails/bundler_version", {
  :display_name => "Bundler Version",
  :description => "The version of gem bundler to install. E.g. `1.0.0.beta.8`.",
  :default => "1.0.0.beta.8",
  :recipes => ["app_rails_nginx::default"]
}

attribute "rails/max_pool_size", {
  :display_name => "Passenger Max Pool Size",
  :description => "Specify the passenger_max_pool_size.",
  :default => "16",
  :recipes => ["app_rails_nginx::default"]
}

attribute "rails/spawn_method", {
  :display_name => "Spawn Method",
  :description => "Specify which Rails spawn method should be used. Ex: `conservative`, `smart`, `smart-lv2`",
  :default => "smart-lv2",
  :recipes => ["app_rails_nginx::default"]
}
