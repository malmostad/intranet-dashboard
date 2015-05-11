# 'test' is a reserved word, 'staging' is used for the "test" environment on the **server**
set :server_address, 'srvubuwebtest23.malmo.se'
server server_address, :web, :app, :db, primary: true
set :rails_env, "test"
set :bundle_without, [:development, :production]
set :bundle_dir, ""
set :bundle_flags, ""

before "deploy", 'backup:mysql'
after 'deploy', 'deploy:restart_daemons'
