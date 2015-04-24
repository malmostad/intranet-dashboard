$envs = ['development', 'test']

$runner_name  = 'vagrant'
$runner_group = 'vagrant'
$runner_home  = '/home/vagrant'
$runner_path  = "${::runner_home}/.rbenv/shims:${::runner_home}/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"

$app_name       = 'dashboard'
$app_home       = '/vagrant'

class { '::mcommons': }

class { '::mcommons::mysql':
  db_password      => '',
  db_root_password => '',
  create_test_db   => true,
  daily_backup     => false,
  ruby_enable      => true,
}

class { '::mcommons::elasticsearch':
  version => '1.4',
  memory  => '48m',
}

class { '::mcommons::memcached':
  memory => 128,
}

class { '::mcommons::ruby':
  version => '2.2.1',
}

class { 'mcommons::ruby::bundle_install': }
class { 'mcommons::ruby::rails': }
class { 'mcommons::ruby::rspec_deps': }
-> mcommons::ruby::db_load_schema { $::envs: }

-> exec {'Create ElasticSearch index':
  command => "${::runner_home}/.rbenv/shims/rake RAILS_ENV=development environment elasticsearch:reindex CLASS='User' ALIAS='employees'; exit 0",
  user    => $::runner_name,
  path    => $::runner_path,
  cwd     => $::app_home,
}

-> exec {'Create ElasticSearch index for test':
  command => "${::runner_home}/.rbenv/shims/rake RAILS_ENV=test environment elasticsearch:reindex CLASS='User' ALIAS='employees'; exit 0",
  user    => $::runner_name,
  path    => $::runner_path,
  cwd     => $::app_home,
}
