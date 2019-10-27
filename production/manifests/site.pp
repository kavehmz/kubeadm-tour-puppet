user { 'mitchell':
  ensure     => 'present',
  uid        => '1000',
  gid        => '1000',
  shell      => '/bin/bash',
  home       => '/home/mitchell',
  managehome => true,
}

group { 'mitchell':
  ensure => 'present',
  gid    => '1000',
}
