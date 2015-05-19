$envs = ['production']

$runner_name  = 'app_runner'
$runner_group = 'app_runner'
$runner_home  = '/home/app_runner'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'dashboard'
$app_home       = "${::runner_home}/${::app_name}/current"

class { '::mcommons': }

class { '::mcommons::mysql':
  ruby_enable => true,
}

class { '::mcommons::elasticsearch':
  version => '1.5',
  memory  => '1g',
}

class { '::mcommons::memcached':
  memory => 512,
}

class { '::mcommons::nginx': }

class { '::mcommons::ruby':
  version => '2.2.2',
}

class { 'mcommons::ruby::unicorn': }
class { 'mcommons::ruby::rails': }

class { 'mcommons::monit': }

-> file { '/etc/monit/conf.d/feed_worker':
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content  => inline_template('check process feed_worker
    with pidfile <%= @app_home -%>/log/feed_worker.pid
    start program "<%= @app_home -%>/lib/run_with_rbenv.sh lib/daemons/feed_worker_ctl start" as uid <%= @runner_name -%> and gid <%= @runner_group %>
    stop program  "<%= @app_home -%>/lib/run_with_rbenv.sh lib/daemons/feed_worker_ctl stop" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 120 seconds
    if cpu > 60% for 2 cycles then alert
    if cpu > 80% for 5 cycles then restart
    if memory usage > 70% for 5 cycles then restart
  '),
}

-> file { "monit config for delayed_job":
  path    => "/etc/monit/conf.d/delayed_job",
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content => inline_template('check process delayed_job
    with pidfile <%= @app_home -%>/tmp/pids/delayed_job.pid
    start program "<%= @app_home -%>/lib/run_with_rbenv.sh bin/delayed_job start" as uid <%= @runner_name -%> and gid <%= @runner_group -%>
    stop program  "<%= @app_home -%>/lib/run_with_rbenv.sh bin/delayed_job stop" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 120 seconds
    if cpu > 60% for 2 cycles then alert
    if cpu > 80% for 5 cycles then restart
    if memory usage > 70% for 5 cycles then restart
  '),
}

-> exec { 'Reload Monit config after service config':
  command => '/usr/bin/monit reload',
}
