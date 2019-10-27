user { 'mitchell':
  ensure     => 'absent',
  uid        => '1000',
  gid        => '1000',
  shell      => '/bin/bash',
  home       => '/home/mitchell',
  managehome => true,
}

group { 'absent':
  ensure => 'present',
  gid    => '1000',
}
