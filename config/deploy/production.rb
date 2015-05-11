set :server_address, 'srvubuwebhost23.malmo.se'
server server_address, :web, :app, :db, primary: true
set :rails_env, "production"
set :bundle_without, [:development, :test]
set :bundle_dir, ""
set :bundle_flags, ""

before "deploy", 'backup:mysql'
after 'deploy', 'deploy:restart_daemons'
