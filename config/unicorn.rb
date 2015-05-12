root = "/home/app_runner/dashboard/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.sitesearch.sock"
worker_processes 7
timeout 15
preload_app false
