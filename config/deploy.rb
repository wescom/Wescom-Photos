# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "wescomphotos"
set :repo_url, "git@example.com:me/Wescom-Photos.git"
#set :ssh_options, { :forward_agent => true }
set :rails_env,   "production"
set :scm,         :git
set :scm_username,    "wescomarchive"     # Git user
set :scm_passphrase,  "Go2cmdarchive"  # Git password

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch,      "origin/master"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/u/apps/wescomphotos"

ARCHIVE1 = "archive1.wescompapers.com"
ARCHIVE2 = "archive2.wescompapers.com"
ARCHIVE3 = "archive3.wescompapers.com"

role :web, ARCHIVE1
role :app, ARCHIVE1
#role :app, ARCHIVE2, :solr => true
#role :db,  ARCHIVE3, :primary => true

set :migration_role, :app

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
