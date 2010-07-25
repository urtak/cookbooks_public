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
  ssh_keyfile = "/tmp/gitkey"
  ssh_wrapper = "#{ssh_keyfile}.sh"

  ruby_block "add ssh key and ssh wrapper script" do
    only_if { !"#{ssh_key}".empty? }
    block do
      ::File.open(ssh_keyfile, "w") { |f| f.write(ssh_key) }
      ::File.open(ssh_wrapper, "w") { |f| f.write("exec ssh -oStrictHostKeyChecking=no -i #{ssh_keyfile} \"$@\"") }
      system("chmod 600 #{ssh_keyfile}")
      system("chmod 700 #{ssh_wrapper}")
    end
  end

  deploy_revision "#{new_resource.destination}" do
    # From do_update_code recipe:
    deploy_to         new_resource.destination
    environment       new_resource.environment
    # From UI:
    # user              "deploy_ninja" TODO deploy as user?
    repository        new_resource.repository
    revision          new_resource.revision
    remote            new_resource.remote
    enable_submodules new_resource.enable_submodules
    restart_command   new_resource.restart_command
    migration_command new_resource.migration_command
    migrate           new_resource.migrate
    # Fixed options:
    shallow_clone     true
    git_ssh_wrapper   ssh_wrapper
    scm_provider      Chef::Provider::Git
    action            :deploy
  end

  ruby_block "clean up ssh key" do
    only_if { !"#{ssh_key}".empty? }
    block do
      ::FileUtils.rm(ssh_keyfile, :force => true)
      ::FileUtils.rm(ssh_wrapper, :force => true)
    end
  end
end
