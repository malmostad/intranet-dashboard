set :rails_env, :test
set :stage, :test
set :branch, "new_server_deployment"
ask(:password, 'for app_runner', echo: false)
server 'srvubuwebtest23.malmo.se', user: 'app_runner', port: 22, password: fetch(:password), roles: %w{web app db}
