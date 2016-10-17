A Hadoop Cluster on AWS with AWS CloudFormation and Chef
========================================================

Description
-----------

This is a Chef recipe and AWS CloudFormation template to deploy a Hadoop cluster (versions, types...) with Apache Spark and lots of other important stuff on Amazon.

Prerequisites
-------------

1. Ensure that a VPC the cluster is to be deployed on resolves private hostnames within a subnetwork. (AWS -> VPC -> Select VPC -> Edit DNS Hostnames -> DNS Hostnames -> Yes)
2. Ensure that AWS CLI is configured (See: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
3. Set postgres credentials in the databag: `./data_bags/postgres/config.json`

After you have checked all the requirements you are ready to proceed by running a command that deployes the cluster: `./deploy.sh`
