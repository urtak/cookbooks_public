#
# Cookbook Name:: repo_git
# Provider:: repo_git
#
# Copyright (c) 2020 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

action :pull do

  ssh_key = new_resource.ssh_key
  ssh_keyfile = nil
  ssh_wrapper = nil
  ruby_block "add ssh key and ssh wrapper script" do
    only_if { !"#{ssh_key}".empty? }
    block do
      ssh_keyfile = "/tmp/gitkey"
      ssh_wrapper = "#{ssh_keyfile}.sh"
      File.open(ssh_keyfile, "w") { |f| f.write(ssh_key) }
      File.open(ssh_wrapper, "w") { |f| f.write("exec ssh -oStrictHostKeyChecking=no -i #{ssh_keyfile} \"$@\"") }
      system("chmod 600 #{ssh_keyfile}")
      system("chmod 700 #{ssh_wrapper}")
    end
  end

  git "sync repo" do
    destination       new_resource.destination
    repository        new_resource.repository
    reference         new_resource.revision
    ssh_wrapper       ssh_wrapper
    enable_submodules new_resource.enable_submodules
    action            :sync
  end

  # TODO use chef-deploy?
  # deploy "/my/deploy/dir" do
  #   repo "git@github.com/whoami/project"
  #   revision "abc123" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  #   user "deploy_ninja"
  #   enable_submodules true
  #   migrate true
  #   migration_command "rake db:migrate"
  #   environment "RAILS_ENV" => "production", "OTHER_ENV" => "foo"
  #   shallow_clone true
  #   action :deploy # or :rollback
  #   restart_command "touch tmp/restart.txt"
  #   git_ssh_wrapper "wrap-ssh4git.sh"
  #   scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
  # end

  ruby_block "clean up ssh key" do
    only_if { !"#{ssh_key}".empty? }
    block do
      FileUtils.rm(ssh_keyfile, :force => true)
      FileUtils.rm(ssh_wrapper, :force => true)
    end
  end
end
