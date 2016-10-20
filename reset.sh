#!/bin/bash
mv .chef/knife.rb.old .chef/knife.rb
mv data_bags/nodes/ambari-server.json.old data_bags/nodes/ambari-server.json
rm .chef/trusted_certs/*
rm nodes.txt
