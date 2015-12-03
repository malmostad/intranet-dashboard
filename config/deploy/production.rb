set :rails_env, :production
set :stage, :production
set :branch, "utf8mb"
ask(:password, 'for app_runner', echo: false)
server 'srvubuwebhost23.malmo.se', user: 'app_runner', port: 22, password: fetch(:password), roles: %w{web app db}
