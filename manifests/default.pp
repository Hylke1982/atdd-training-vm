class { 'apt':
  always_apt_update    => true,
  update_timeout       => undef,
  purge_sources_list   => true
}

class atddtraininginstance::install {

  class { 'atddtraininginstance::install::debs': } ->
  class { 'java':
    distribution => 'jdk'
  } ->

  package { ['xfce4', 'xfce4-goodies']:
    ensure => installed,
  } ->

  package { 'lightdm':
    ensure => installed,
  }

  service { 'lightdm':
    ensure  => "running",
    enable  => true,
    require => Package["lightdm"]
  }

  user { 'atdd':
    comment  => "ATDD user",
    ensure   => "present",
    home     => "/home/atdd",
    uid      => 2001,
    shell    => "/bin/bash",
    password => '$1$JaokCGkz$V41vyU.z2BuB8ZJvNB.1g0'
  } ->

  file { '/home/atdd':
    ensure => directory,
    owner  => 'atdd',
  } ->

  file { '/home/atdd/.xinitrc':
    path    => "/home/atdd/.xinitrc",
    owner   => "atdd",
    content => "exec startxfce4",
  }


  file { '/home/atdd/.xsession':
    path    => "/home/atdd/.xsession",
    owner   => "atdd",
    content => "xfce4-session",
  }
}

class atddtraininginstance::install::debs {
  apt::source { 'deb':
    location          => 'http://ftp.nl.debian.org/debian/',
    release           => "wheezy",
    repos             => 'main',
    include_src       => true
  }

  apt::source { 'deb-updates':
    location          => 'http://ftp.nl.debian.org/debian/',
    release           => "wheezy-updates",
    repos             => 'main',
    include_src       => true
  }

  apt::source { 'deb-security':
    location          => 'http://ftp.nl.debian.org/debian-security/',
    release           => "wheezy/updates",
    repos             => 'main',
    include_src       => true
  }
}

node default {

  class { 'atddtraininginstance::install' : } ->
  package{ 'git-core':
    ensure => 'installed'
  }
}
