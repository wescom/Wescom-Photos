# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "wescomphotos"
set :repo_url, "git@github.com:wescom/Wescom-Photos.git"
set :rails_env,   "production"

# Settings for Git
set :scm_username,    "wescomarchive"     # Git user
set :scm_passphrase,  "Go2cmdarchive"     # Git password
set :branch,      "master"

# set :deploy_user, "archive"
set :deploy_to, "/u/apps/wescomphotos"
set :migration_role, :app

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc "Makes sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

#  %w[start stop restart].each do |command|
#    desc "#{command} Unicorn server."
#    task command do
#      on roles(:app) do
#        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
#      end
#    end
#  end
#  after :deploy, "deploy:restart"
#  after :rollback, "deploy:restart"

  before :deploy, "deploy:check_revision"

end