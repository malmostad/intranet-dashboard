# 'test' is a reserved word, 'staging' is used for the "test" environment on the **server**
set :rails_env, "test"
set :bundle_without, [:development, :production]
set :bundle_dir, ""
set :bundle_flags, ""
set :server_address, config['server_address_staging']

before "deploy", 'backup:mysql'
after 'deploy', 'deploy:restart_daemons'
