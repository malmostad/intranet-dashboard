require 'erb'
I18n.config.enforce_available_locales = false

set :backup_dir, '/home/app_runner/deploy_dump/'
set :shared_path, -> { shared_path }

set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :application, 'dashboard'
set :repo_url, "https://github.com/malmostad/intranet-dashboard.git"
set :user, 'app_runner'
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :scm, :git
set :deploy_via, :remote_cache

set :pty, true
set :forward_agent, true

set :linked_files, %w{config/database.yml config/app_config.yml }
set :linked_dirs, %w{log tmp/pids tmp/sockets public/uploads public/avatars reports}

set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }
set :keep_releases, 5

namespace :deploy do
  %w[stop start restart upgrade].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:all), except: {no_release: true} do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  desc "Full restart of unicorn server"
  task :full_restart do
    on roles(:all), except: {no_release: true} do
      execute "/etc/init.d/unicorn_#{fetch(:application)} restart"
    end
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:all) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "Are you sure?"
  task :are_you_sure do
    on roles(:all) do |server|
      puts ""
      puts "Environment:   \033[0;32m#{fetch(:rails_env)}\033[0m"
      puts "Remote branch: \033[0;32m#{fetch(:branch)}\033[0m"
      puts "Server:        \033[0;32m#{server.hostname}\033[0m"
      puts ""
      puts "Do you want to deploy?"
      set :continue, ask("[y/n]:", "n")
      if fetch(:continue).downcase != 'y' && fetch(:continue).downcase != 'yes'
        puts "Deployment stopped"
        exit
      else
        puts "Deployment starting"
      end
    end
  end

  desc 'Restart daemons'
  task :restart_daemons do
    on roles(:all) do
      puts "Restarting daemons, this can take a while..."
      execute "RAILS_ENV=#{fetch(:rails_env)} #{fetch(:release_path)}/lib/daemons/feed_worker_ctl restart"
      execute "RAILS_ENV=#{fetch(:rails_env)} #{fetch(:release_path)}/bin/delayed_job restart"
    end
  end

  desc 'Perform a backup using mysqldump'
  task :mysql_backup do
    on roles(:all) do
      filepath = "#{fetch(:backup_dir)}predeploy-#{fetch(:release_name)}.sql.bz2"
      text = capture "cat #{fetch(:shared_path)}/config/database.yml"
      yaml = YAML::load(text)

      execute "mysqldump -u #{fetch(:yaml)[fetch(:rails_env)]['username']} -p #{fetch(:yaml)[fetch(:rails_env)]['database']} | bzip2 -c > #{fetch(:filepath)}" do |ch, stream, out|
        ch.send_data "#{fetch(:yaml)[fetch(:rails_env)]['password']}\n" if out =~ /^Enter password:/
      end
    end
  end

  before :starting, "deploy:are_you_sure"
  before :starting, "deploy:check_revision"
  before :starting, "deploy:mysql_backup"
  after :published, "deploy:full_restart"
  after :published, "deploy:restart_daemons"
  after :finishing, "deploy:cleanup"
end
