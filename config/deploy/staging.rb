 # 'test' is a reserved word, 'staging' is used for the "test" environment on the **server**
set :rails_env, "test"
set :deploy_to, "/var/www/dashboard/test"
set :bundle_without, [:development, :production]
set :bundle_dir, ""
set :bundle_flags, ""
after 'deploy', 'deploy:restart_daemons'
