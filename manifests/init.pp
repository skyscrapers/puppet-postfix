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

# == Class: postfix
#
# This class is able to activate and configure postfix client
#
# === Parameters
#
# [*root_email*]
#   Email address of root account
#
# [*relayhosts*]
#   Array of all the relay hosts.
#
# [*myorigin*]
#   Specify myorigin.
#
# === Examples
#
# * Installation of postfix
#     class {'postfix':
#       root_email    => 'email@example.com',
#       relayhosts    => ['[mail01.example.com]','[mail02.example.com]:2525'],
#       myorigin      => 'server.example.com'
#     }
# * Installation of postfix with smtp relay authentication
#     class {'postfix':
#       root_email               => 'email@example.com',
#       relayhosts               => ['[mail01.example.com]','[mail02.example.com]:2525'],
#       myorigin                 => 'server.example.com'
#       smtp_relay_auth_enabled  => true
#       smtp_relay_auth_email    => user@example.com
#       smtp_relay_auth_password => secret_password
#
#     }
#

class postfix(
  $root_email                   = $postfix::params::root_email,
  $relayhosts                   = undef,
  $extranetwork                 = undef,
  $myorigin                     = $postfix::params::myorigin,
  $enabled                      = $postfix::params::enabled,
  $smtp_relay_auth_enabled      = false,
  $smtp_relay_auth_email        = undef,
  $smtp_relay_auth_password     = undef

) inherits postfix::params {

  contain postfix::install
  contain postfix::config
  contain postfix::service

  Class['postfix::install'] -> Class['postfix::config'] ~> Class['postfix::service']

  if !$enabled {
    contain postfix::disabled
  }
}
