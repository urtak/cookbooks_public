# Raise trouble for required attributes.
raise "missing rails/code/url" if "#{node[:rails][:code][:url]}".empty?

# include the public recipe to install git
include_recipe "git::default"

# grab application source from remote repository
repo "Get Repository" do
  url node[:rails][:code][:url]
  branch node[:rails][:code][:branch] 
  dest node[:rails][:code][:destination]
  cred node[:rails][:code][:credentials]
  action :pull
  provider "repo_git"
end
