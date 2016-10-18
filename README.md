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
4. Set the location of the AWS private key in the `deploy.sh:6` - a script in the root directory of the repository. It's needed to reach ec2 instances via ssh `deploy.sh:56-59`. (http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
5. Define variables with which the Chef Server is to be configured in the `deploy.sh:32` (refer to this page for more information (items 5-6): https://docs.chef.io/install_server.html)

After you have checked all the requirements you are ready to proceed by running the script that deployes the cluster: `./deploy.sh`
