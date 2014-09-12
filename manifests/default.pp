# Configure APT
class { 'apt':
  always_apt_update    => true,
  update_timeout       => undef,
  purge_sources_list   => true
}

# ATDD training machine installation instructiosn
class atddtraininginstance::install {

  class { 'atddtraininginstance::install::debs': } ->
  class { 'atddtraininginstance::install::xfce': } ->
  class { 'atddtraininginstance::install::atdduser': } ->
  class { 'atddtraininginstance::install::sourcecode': } ->
  class { 'atddtraininginstance::install::tools': } ->

  class { 'java':
    distribution => 'jdk'
  }


}

# Add correct APT repos
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

# Source code to download
class atddtraininginstance::install::sourcecode {
  git::reposync { 'TDDTrainingApplicationCC':
    source_url      => 'https://github.com/Hylke1982/TDDTrainingApplicationCC.git',
    destination_dir => '/home/atdd/workspace/TDDTrainingApplicationCC',
    owner           => 'atdd',
    group           => 'atdd'
  }
}

# Install tools
class atddtraininginstance::install::tools {
  package { ['maven', 'eclipse']:
    ensure => installed,
  }
}

# Install graphical user interface
class atddtraininginstance::install::xfce {
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
}

# Add 'atdd' user
class atddtraininginstance::install::atdduser {
  user { 'atdd':
    comment  => "ATDD user",
    ensure   => "present",
    home     => "/home/atdd",
    uid      => 2001,
    shell    => "/bin/bash",
    password => '$1$JaokCGkz$V41vyU.z2BuB8ZJvNB.1g0'
  } ->

  file { ['/home/atdd','/home/atdd/workspace']:
    ensure => directory,
    owner  => 'atdd',
    groupd => 'atdd'
  } ->

  file { '/home/atdd/.xinitrc':
    path    => "/home/atdd/.xinitrc",
    owner   => "atdd",
    group   => 'atdd',
    content => "exec startxfce4",
  }


  file { '/home/atdd/.xsession':
    path    => "/home/atdd/.xsession",
    owner   => "atdd",
    group   => "atdd",
    content => "xfce4-session",
  }
}

# Configure node
node default {

  class { 'atddtraininginstance::install' : } ->
  package{ 'git-core':
    ensure => 'installed'
  }
}
