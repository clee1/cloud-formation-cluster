#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright (c) 2016 Eugen Prokhorenko, All Rights Reserved.

package "wget"
package "vim"
package "git"
package "mc"
package "net-tools"
package "nfs-utils"
package "ntp"

hostsfile_entry '127.0.0.1' do
  hostname  'localhost'
end

hostsfile_entry '127.0.1.1' do
  hostname  'localhost'
end

hostsfile_entry '0.0.0.0' do
  hostname  node['fqdn']
end

service "ntpd" do
  action [:enable, :start]
end

service "firewalld" do
  action [:disable, :stop]
end

# setting ip address of the ambari server
# do i even need this?
#
# hostsfile_entry data_bag_item("ambari-server", "ip") do
#   hostname  data_bag_item("ambari-server", "hostname")
#   action    :create
# end
#
# AGENTS.each do |n|
#   hostsfile_entry "10.20.30.#{ 100 + n }" do
#     hostname  "zulu-#{ n }.cluster"
#     action    :create
#   end
# end

=begin

PROBABLY NOT NEEDED EITHER, BECAUSE THESE WERE USED
TO SSH INTO VAGRANT BOXES.

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file "/root/.ssh/id_rsa" do
  owner "root"
  group "root"
  mode "0400"
  action :create
end

cookbook_file "/root/.ssh/id_rsa.pub" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

cookbook_file "/root/.ssh/authorized_keys" do
  source "id_rsa.pub"
  mode "0644"
  owner "root"
  group "root"
end

=end
