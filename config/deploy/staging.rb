set :rails_env, :test
set :stage, :test
set :branch, "master"
ask(:password, nil, echo: false)
server 'srvubuwebtest23.malmo.se', user: 'app_runner', port: 22, password: fetch(:password), roles: %w{web app db}
