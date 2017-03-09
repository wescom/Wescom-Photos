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
    before :deploy, :check_revision do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end

  desc "Update links"
  after :finished, :update_links do
    on roles(:web) do
      execute "rm -rf #{release_path}/solr #{release_path}/log #{release_path}/public/system #{release_path}/tmp/pids"
      execute "ln -s /WescomArchive/solr #{release_path}/solr"
      execute "mkdir -p #{release_path}/public && ln -s #{shared_path}/system #{release_path}/public/system"
      execute "ln -s #{shared_path}/log #{release_path}/log"
      execute "mkdir -p #{release_path}/tmp && ln -s #{shared_path}/pids #{release_path}/tmp/pids"
    end
  end

  desc "Upload files not witin Git"
  after :finished, :upload_files do
    on roles(:web) do
      within "#{current_path}" do
        execute "mkdir -p #{shared_path}/config"
        upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
        upload! StringIO.new(File.read("config/application.yml")), "#{shared_path}/config/application.yml"
        upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
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

end

# Unicorn tasks
#require 'capistrano-unicorn'
#after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
#after 'deploy:restart', 'unicorn:restart'   # app preloaded

#after 'deploy:restart' do
#  run "echo 'Setting permissions on unicorn.pid' && sleep 2 && chmod 777 #{shared_path}/pids/unicorn.pid"
#  run "echo 'Change group on unicorn.pid' && chown :ads #{shared_path}/pids/unicorn.pid"
#end
