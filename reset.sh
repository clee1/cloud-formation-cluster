#!/bin/bash
mv -v .chef/knife.rb.old .chef/knife.rb
mv -v tunnel.sh.old tunnel.sh
git checkout data_bags/instances/ambari-server.json
git checkout data_bags/instances/ambari-agents.json
rm -v data_bags/instances/ambari-server.json.old
rm -v data_bags/instances/ambari-agents.json.old
rm -v .chef/trusted_certs/*
rm -v .chef/syntaxcache/*
rm -v nodes.txt
