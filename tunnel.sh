#!/bin/bash
ssh -L 9999:localhost:8080 -N centos@<AMBARI_SERVER_IP> -i ~/default.pem
