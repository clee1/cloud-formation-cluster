#
# Cookbook Name:: ambari-server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

file '/tmp/ambari-server' do
  content 'This is an ambari server.'
end
