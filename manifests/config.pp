##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2014 - http://skyscrape.rs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# == Class postfix::config
#
# This class is called from postfix
#
class postfix::config inherits ::postfix {
  $ensure = $postfix::enabled ? {
    true => file,
    false => absent
  }

  file {
    '/etc/postfix/main.cf':
      ensure  => $ensure,
      content => template('postfix/etc/postfix/main.cf.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,
      notify  => Service['postfix'];

    '/etc/aliases':
      ensure  => $ensure,
      content => template('postfix/etc/aliases.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,
      notify  => $postfix::enabled ? {
        true => Exec['postalias'],
        false => []
      };
  }


  if $postfix::gmail_smtp_relay_enabled {
    file { "/etc/postfix/sasl/sasl_passwd":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
      content => template('postfix/etc/postfix/sasl/sasl_passwd/sasl_passwd.erb'),
    }
    exec { 'create_hash_db':
      user    => 'root',
      path    => '/usr/bin:/usr/sbin:/bin/:/sbin',
      command => 'postmap /etc/postfix/sasl/sasl_passwd && chmod 0600 /etc/postfix/sasl/sasl_passwd.db && service postfix reload',
      creates => '/etc/icinga2/postgres_module_loaded.txt',
      subscribe => File['/etc/postfix/sasl/sasl_passwd'],
      refresh_only => true,
    }
  }

}
