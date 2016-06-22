set :rails_env, "production"
set :deploy_to, "/var/www/dashboard/production"
set :bundle_without, [:development, :test]
set :bundle_dir, ""
set :bundle_flags, ""

before "deploy", 'backup:mysql'
after 'deploy', 'deploy:restart_daemons'
