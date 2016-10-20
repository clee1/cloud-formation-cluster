#
# Cookbook Name:: ambari-agent
# Recipe:: default
#
# Copyright (c) 2016 Eugen Prokhorenko, All Rights Reserved.

remote_file '/etc/yum.repos.d/ambari.repo' do
  source "http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari.repo"
end

service "rpcbind" do
  action [:enable, :start]
end

package "java-1.7.0-openjdk"
package "javapackages-tools"
package "ambari-agent"

template '/etc/ambari-agent/conf/ambari-agent.ini' do
  source 'ambari-agent.ini.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables ({ ambari_server_hostname: data_bag_item("nodes", "ambari-server") })
  action :create
end

systemd_service "ambari" do
  description "Ambari agent daemon"
  install do
    wanted_by 'multi-user.target'
  end
  service do
    type 'forking'
    exec_start '/usr/sbin/ambari-agent start'
    exec_stop '/usr/sbin/ambari-agent stop'
  end
end

service "ambari" do
  action [:enable, :start]
end
