set :rails_env, "production"
set :bundle_without, [:development, :test]
set :bundle_dir, ""
set :bundle_flags, ""
set :server_address, config['server_address']

before "deploy", 'backup:mysql'
after 'deploy', 'deploy:restart_daemons'
