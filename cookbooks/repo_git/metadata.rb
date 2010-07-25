maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Git fast version control system"
version          "0.0.1"
provides         "provider:repo"
recipe           "repo_git::default", "Default pattern of loading packages and resources provided"

grouping "repo/default", {
  :display_name => "Git Client Default Settings",
  :description => "Settings for managing a Git source repository",
  :databag => true
}

attribute "repo/default/provider", {
  :display_name => "Repository Provider Type",
  :description => "Deploy with git.",
  :default => "repo_git"
}

attribute "repo/default/repository", {
  :display_name => "Repository URL",
  :description => "The git url.",
  :required => true
}

attribute "repo/default/revision", {
  :display_name => "Branch/Tag/Revision",
  :description => "Which branch/tag/revision to deploy.",
  :default => "master",
  :required => false
}

attribute "repo/default/remote", {
  :display_name => "Remote",
  :description => "The remote to use for pulling.",
  :default => "origin",
  :required => false
}

attribute "repo/default/enable_submodules", {
  :display_name => "Enable Submodules",
  :description => "Automatically checkout the repo's submodules during deploy?",
  :default => "false",
  :required => false
}

attribute "repo/default/restart_command", {
  :display_name => "Restart Command",
  :description => "The command used to restart the web app.",
  :default => "touch tmp/restart.txt",
  :required => false
}

attribute "repo/default/migration_command", {
  :display_name => "Migrate Command",
  :description => "The command used to migrate the database.",
  :default => "rake db:migrate",
  :required => false
}

attribute "repo/default/migrate", {
  :display_name => "Migrate the database?",
  :description => "Run the migration_command during deploy.",
  :default => "false",
  :required => false
}

attribute "repo/default/ssh_key", {
  :display_name => "SSH Private Key",
  :description => "This private ssh key will be used to access your git repository URL.",
  :default => nil,
  :required => false
}
