node default {
  package { 'iptables':
    ensure => installed,
    name   => 'iptables',
  }
  package { 'arptables':
    ensure => installed,
    name   => 'arptables',
  }
  package { 'ebtables':
    ensure => installed,
    name   => 'ebtables',
  }

  alternatives { 'iptables':
    path => '/usr/sbin/iptables-legacy',
  }
  alternatives { 'ip6tables':
    path => '/usr/sbin/ip6tables-legacy',
  }
  alternatives { 'arptables':
    path => '/usr/sbin/arptables-legacy',
  }
  alternatives { 'ebtables':
    path => '/usr/sbin/ebtables-legacy',
  }

  file { '/etc/docker/daemon.json':
    ensure  => present,
    content => '
      {
        "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
          "max-size": "100m"
        },
        "storage-driver": "overlay2"
      }
    ',
  }

  include 'docker'

  package { 'apt-transport-https':
    ensure => installed,
    name   => 'apt-transport-https',
  }
  package { 'curl':
    ensure => installed,
    name   => 'curl',
  }

  exec { '/usr/bin/curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | /usr/bin/apt-key add -': }
  exec { '/usr/bin/echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list': }
  exec { '/usr/bin/apt-get update': }
  exec { '/usr/bin/apt-get install -y kubelet kubeadm kubectl': }
  exec { '/usr/bin/apt-mark hold kubelet kubeadm kubectl': }

  exec { '/usr/bin/systemctl daemon-reload': }
  exec { '/usr/bin/systemctl restart kubelet': }
}

if lookup('myrole') !='k8s-server' {
  unless '/usr/bin/test -f /opt/kubeadmin.txt' {
    exec { '/usr/bin/kubeadm init --pod-network-cidr=192.168.0.0/16 > /opt/kubeadmin.txt': }
    exec { '/usr/bin/kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml':}
  }
}
