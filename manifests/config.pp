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
class postfix::config {
  file {
    '/etc/postfix/main.cf':
      ensure  => file,
      content => template('postfix/etc/postfix/main.cf.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,
      notify  => Service['postfix'];

    '/etc/aliases':
      ensure  => file,
      content => template('postfix/etc/aliases.erb'),
      mode    => '0644',
      owner   => root,
      group   => root,
      notify  => Exec['postalias'];
  }
}