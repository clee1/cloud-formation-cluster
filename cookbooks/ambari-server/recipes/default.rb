#
# Cookbook Name:: ambari-server
# Recipe:: default
#
# Copyright (c) 2016 Eugen Prokhorenko, All Rights Reserved.

package 'gcc'
package "postgresql-server"
package "postgresql-jdbc"

execute "setup postgresql" do
  command "postgresql-setup initdb"
end

service "postgresql" do
  action [:enable, :start]
end

service "rpcbind" do
  action [:enable, :start]
end

postgresql_jdbc_jar = "/usr/share/java/postgresql-jdbc.jar"

file postgresql_jdbc_jar do
  owner 'root'
  group 'root'
  mode '0644'
end

config = data_bag_item("postgres", "config")

node.default['postgresql']['password']['postgres'] = config['postgres_password']
node.default['postgresql']['recovery_user'] = config['pg_recovery_user']
node.default['postgresql']['recovery_user_pass'] = config['pg_recovery_pass']
node.default['postgresql']['recovery']['standby_mode'] = 'off'
node.default['postgresql']['config']['wal_level'] = 'hot_standby'

include_recipe 'postgresql::ruby'
include_recipe 'postgresql::default'
include_recipe 'postgresql::server'

postgresql_connection_info = {
  host:     '127.0.0.1',
  port:     node['postgresql']['config']['port'],
  username: 'postgres',
  password: node['postgresql']['password']['postgres']
}

postgresql_database_user config['dbuser'] do
  connection postgresql_connection_info
  password config['dbpass']
  action :create
end

postgresql_database config['dbname'] do
  connection postgresql_connection_info
  connection_limit '-1'
  owner config['dbuser']
  action :create
end

file '/etc/yum/pluginconf.d/refresh-packagekit.conf' do
  owner   'root'
  group   'root'
  mode    '0644'
  content 'enabled=0'
end

remote_file '/etc/yum.repos.d/ambari.repo' do
  source "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari.repo"
end

package "ambari-server"

systemd_service "ambari" do
  description "Ambari server daemon"
  install do
    wanted_by 'multi-user.target'
  end
  service do
    type 'forking'
    exec_start '/usr/sbin/ambari-server start'
    exec_stop '/usr/sbin/ambari-server stop'
  end
end

execute "setup ambari" do
  command "ambari-server setup -s"
end

execute "configure ambari to use postgresql" do
  command "ambari-server setup --jdbc-db=postgres --jdbc-driver=#{ postgresql_jdbc_jar }"
end

service "ambari" do
  action [:enable, :start]
end
