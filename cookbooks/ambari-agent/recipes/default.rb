#
# Cookbook Name:: ambari-agent
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

file '/tmp/ambari-agent' do
  content 'This is an ambari agent.'
end
