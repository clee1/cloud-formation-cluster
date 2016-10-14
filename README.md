A Hadoop Cluster on AWS with AWS CloudFormation and Chef
========================================================

Description
-----------

This is a Chef recipe and AWS CloudFormation template to deploy a Hadoop cluster (versions, types...) with Apache Spark and lots of other important stuff on Amazon.

Prerequisites
-------------

1. Ensure that a VPC the cluster is to be deployed on resolves private hostnames within a subnetwork. (AWS -> VPC -> Select VPC -> Edit DNS Hostnames -> DNS Hostnames -> Yes)
2. Ensure that AWS keys are set (???)
3. Run a command that deployes a cluster (describe this command below) aws clodformation create-stack ...
4. Run a command that describes all ips and hostnames
5. Populate a databag that I will add in a couple of minutes...
6. Set postgres credentials in a databag.
6. Set the proper ip address of the chef server in the `.chef/knife.rb` file.
6. From your workstation: knife ssl fetch; knife bootstrap...
7. Put `id_rsa`, `id_rsa.pub` and `authorized_keys` files into `cookbooks/common/files` directory. DO I STILL NEED THIS?
7. ???
8. Profit!!!
