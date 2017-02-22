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
  version => '5.x',
  memory  => '1g',
}

class { '::mcommons::memcached':
  memory => 512,
}

class { '::mcommons::nginx': }

class { '::mcommons::ruby':
  version => '2.3.3',
}

class { 'mcommons::ruby::unicorn': }
class { 'mcommons::ruby::rails': }

class { 'mcommons::monit': }

# Puppet can't read local template files ...
-> file { '/etc/monit/conf-available/feed_worker_main_feeds':
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content  => inline_template('check process feed_worker_main_feeds
    with pidfile <%= @app_home -%>/dashboard/shared/tmp/pids/feed_worker_main_feeds.pid
    start program "<%= @runner_home -%>/run_with_rbenv rake feed_worker:start[main_feeds]" as uid <%= @runner_name -%> and gid <%= @runner_group -%>
    stop program  "<%= @runner_home -%>/run_with_rbenv rake feed_worker:stop[main_feeds]" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 60 seconds
    if cpu > 60% for 2 cycles then alert
    if cpu > 80% for 5 cycles then restart
    if memory usage > 70% for 5 cycles then restart
    if changed pid 2 times within 60 cycles then alert
  '),
}

-> file { '/etc/monit/conf-available/feed_worker_user_feeds':
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content  => inline_template('check process feed_worker_user_feeds
    with pidfile <%= @app_home -%>/dashboard/shared/tmp/pids/feed_worker_user_feeds.pid
    start program "<%= @runner_home -%>/run_with_rbenv rake feed_worker:start[user_feeds]" as uid <%= @runner_name -%> and gid <%= @runner_group -%>
    stop program  "<%= @runner_home -%>/run_with_rbenv rake feed_worker:stop[user_feeds]" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 60 seconds
    if cpu > 60% for 2 cycles then alert
    if cpu > 80% for 5 cycles then restart
    if memory usage > 70% for 5 cycles then restart
    if changed pid 2 times within 60 cycles then alert
  '),
}

-> file { "monit config for delayed_job":
  path    => "/etc/monit/conf.d/delayed_job",
  owner   => 'root',
  group   => 'root',
  mode    => '0700',
  content => inline_template('check process delayed_job
    with pidfile <%= @app_home -%>/tmp/pids/delayed_job.pid
    start program "<%= @runner_home -%>/run_with_rbenv ruby <%= @app_home -%>/bin/delayed_job start" as uid <%= @runner_name -%> and gid <%= @runner_group %>
    stop program  "<%= @runner_home -%>/run_with_rbenv ruby <%= @app_home -%>/bin/delayed_job stop" as uid <%= @runner_name -%> and gid <%= @runner_group -%> with timeout 120 seconds
    if cpu > 200% for 2 cycles then alert
    if cpu > 200% for 5 cycles then restart
    if memory usage > 25% for 5 cycles then restart
    if changed pid 2 times within 60 cycles then alert
  '),
}

-> exec { 'Reload Monit config after service config':
  command => '/usr/bin/monit reload',
}
