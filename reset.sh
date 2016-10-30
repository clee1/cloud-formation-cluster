#!/bin/bash
mv -v .chef/knife.rb.old .chef/knife.rb
git checkout data_bags/nodes/ambari-server.json
git checkout data_bags/nodes/ambari-agents.json
rm -v data_bags/nodes/ambari-server.json.old
rm -v data_bags/nodes/ambari-agents.json.old
rm -v .chef/trusted_certs/*
rm -v .chef/syntaxcache/*
rm -v nodes.txt
