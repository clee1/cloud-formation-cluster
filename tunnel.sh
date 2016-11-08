#!/bin/bash
aws_key=~/default.pem
ssh -L 9999:localhost:8080 -N centos@<AMBARI_SERVER_IP> -i $aws_key
