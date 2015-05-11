# The Capistrano tasks will use your **working copy**, compile the assets and deploy them to the server_address
# Execute one of the following to deploy into test or production:
#   $ bundle exec cap staging deploy
#   $ bundle exec cap production deploy
# Rollback one step:
#   $ bundle exec cap [staging|production] deploy:rollback

require "bundler/capistrano"
require 'capistrano/ext/multistage'
require "delayed/recipes"

set :application, "dashboard_komin"

set :stages, %w(staging production) # 'test' is a reserved word
set :default_stage, "staging"
set :user, 'app_runner'
set :deploy_to, "/home/app_runner/dashboard"

set :shared_children, shared_children + %w{reports}

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
require "whenever/capistrano"

_cset :asset_env, "RAILS_GROUPS=assets"
_cset :assets_prefix, "assets"
_cset :assets_role, [:web]
_cset :normalize_asset_timestamps, true
set :precompile_assets, "locally" # remote, locally or none

set :use_sudo, false

set :backup_dir, '/home/app_runner/deploy_dump/'

set :scm, :none
set :repository, "."
set :deploy_via, :copy # Use local copy, be sure to update to the stuff you want to deploy
set :copy_exclude, ["spec", "log/*", "**/.git*", "**/.svn", "tmp/*", "doc", "**/.DS_Store",
  "**/*.example", "config/database.yml*", "config/deploy.yml*", "config/app_config.yml*",
  ".bundle", ".rspec", ".ruby-version", "data/*"]

# set :scm, :git

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

before "deploy", "prompt:continue", "assets:precompile_#{precompile_assets}"
before 'deploy:restart', 'deploy:symlink_config', 'deploy:migrate'
after 'deploy', 'deploy:cleanup', 'assets:cleanup'
# More callbacks in production.rb deploy file

namespace :deploy do
  desc 'Symlink to shared files'
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml"
  end

  desc 'Restart the application'
  task :restart do
    run "touch #{release_path}/tmp/restart.txt"
  end

  desc 'Restart daemons'
  task :restart_daemons do
    puts "Restarting daemons, this can take a while..."
    run "RAILS_ENV=#{rails_env} #{release_path}/lib/daemons/feed_worker_ctl restart"
    run "RAILS_ENV=#{rails_env} #{release_path}/bin/delayed_job restart"
  end
end

namespace :assets do
  desc "Precompile assets on server"
  task :precompile_remote, roles: assets_role, :except => { :no_release => true } do
    run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
  end

  desc "Precompile assets locally"
  task :precompile_locally do
    run_locally("rake assets:clobber RAILS_ENV=#{rails_env} && rake assets:precompile RAILS_ENV=#{rails_env}")
  end

  desc "Don't precompile assets"
  task :precompile_none do
  end

  desc "Remove locally compiled assets"
  task :cleanup do
    run_locally("rake assets:clobber RAILS_ENV=#{rails_env}")
  end
end

namespace :prompt do
  task :continue do
    puts "\n#{shared_children}"
    puts "\nThis will use your **working copy** and deploy a **#{rails_env}** version to #{server_address} #{releases_path}/#{release_name}"
    puts "Task performed:"
    puts "  * Assets compiled #{precompile_assets}"
    puts "  * Database dumped to #{backup_dir}"
    puts "  * Migration run"
    puts "  * App restart and linked as current version"
    puts "  * Daemons restart"
    continue = Capistrano::CLI.ui.ask "\nDo you want to continue [y/n]: "
    if continue.downcase != 'y' && continue.downcase != 'yes'
      puts "Deployment halted by user"
      Kernel.exit(1)
    end
  end
end

namespace :backup do
  desc 'performs a backup using mysqldump'
  task :mysql, :roles => :db, :only => { :primary => true } do
    filepath = "#{backup_dir}#{application}-#{rails_env}-predeploy-#{release_name}.sql.bz2"
    text = capture "cat #{shared_path}/config/database.yml"
    yaml = YAML::load(text)

    run "mysqldump -u #{yaml[rails_env]['username']} -p #{yaml[rails_env]['database']} | bzip2 -c > #{filepath}" do |ch, stream, out|
      ch.send_data "#{yaml[rails_env]['password']}\n" if out =~ /^Enter password:/
    end
  end
end
