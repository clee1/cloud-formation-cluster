#
# Cookbook Name:: ambari-server
# Recipe:: blueprint
#
# Copyright (c) 2016 Eugen Prokhorenko, All Rights Reserved.

blueprint_location = "/tmp/blueprint-default"
cluster_creation_template_location = "/tmp/cluster-creation-template"

cookbook_file blueprint_location do
  source "blueprint-default"
  action :create
end

template cluster_creation_template_location do
  source "cluster-creation-template.erb"
  variables ({ agents: data_bag_item("nodes", "ambari-agents") })
  action :create
end

execute "check ambari server" do
  command "curl http://localhost:8080/api/v1/clusters"
  retries 5
  retry_delay 300

  notifies :post, "http_request[register blueprint]", :delayed
  notifies :post, "http_request[create cluster]", :delayed
end

http_request "register blueprint" do
  url "http://localhost:8080/api/v1/blueprints/default"
  headers({ "X-Requested-By" => "ambari" })
  message { ::File.read(blueprint_location) }

  action :nothing
end

http_request "create cluster" do
  url "http://localhost:8080/api/v1/clusters/HadoopCluster"
  headers({ "X-Requested-By" => "ambari" })
  message { ::File.read(cluster_creation_template_location) }

  action :nothing
end
