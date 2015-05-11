set :rails_env, :production
set :stage, :production
set :branch, "master"
ask(:password, nil, echo: false)
server 'srvubuwebhost23.malmo.se', user: 'app_runner', port: 22, password: fetch(:password), roles: %w{web app db}
