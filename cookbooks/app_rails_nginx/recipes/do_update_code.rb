include_recipe "repo_git::default"

repo "default" do
  destination node[:rails][:code][:destination]
  environment {"RAILS_ENV" => node[:rails][:environment]}
  action      :pull
end

# TODO remove?
# # grab application source from remote repository
# repo "Get Repository" do
#   url node[:rails][:code][:url]
#   branch node[:rails][:code][:branch] 
#   dest node[:rails][:code][:destination]
#   cred node[:rails][:code][:credentials]
#   action :pull
#   provider "repo_git"
# end
