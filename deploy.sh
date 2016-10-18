#!/usr/bin/env bash
set -e
export AWS_DEFAULT_OUTPUT="text"

vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[0].{VpcId:VpcId}')
subnet_id=$(aws ec2 describe-subnets --query 'Subnets[0].{SubnetId:SubnetId}')
subnet_cidr=$(aws ec2 describe-subnets --query 'Subnets[0].{CidrBlock:CidrBlock}')

echo Using VPC: $vpc_id
echo Using subnetwork: $subnet_id [ $subnet_cidr ]

# 0) Deploy the cluster:

aws cloudformation create-stack \
  --region "us-east-1" \
  --stack-name "HadoopCluster" \
  --template-body file://_cloud_formation_template/HadoopCluster.template \
  --parameters \
    ParameterKey=KeyName,ParameterValue=default \
    ParameterKey=AgentsInstanceTypeParameter,ParameterValue=t2.micro \
    ParameterKey=ChefServerInstanceTypeParameter,ParameterValue=t2.micro \
    ParameterKey=VpcId,ParameterValue=$vpc_id \
    ParameterKey=SubnetID,ParameterValue=$subnet_id \
    ParameterKey=SubnetCidr,ParameterValue=$subnet_cidr

# Here wait until all the instances are ready.

# 1) Set domain name of the Chef Server:

chef_server_domain_name=$(aws ec2 describe-instances --filters \
  Name=tag:Name,Values=ChefServer \
  Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].{IP:PublicDnsName}')

sed ./.chef/knife.rb --in-place=.old --expression="s/<CHEF_SERVER_URL>/$chef_server_domain_name/g"

# 2) Set information about ip and domain name of the Ambari Server:

ambari_server_ip=$(aws ec2 describe-instances --filters \
  Name=tag:Name,Values=AmbariServer \
  Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].{IP:PublicIpAddress}')

ambari_server_hostname=$(aws ec2 describe-instances --filters \
  Name=tag:Name,Values=AmbariServer \
  Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].{IP:PublicDnsName}')

sed ./data_bags/nodes/ambari-server.json -i.old -e "s/<AMBARI_SERVER_IP>/$ambari_server_ip; s/<AMBARI_SERVER_HOSTNAME>/$ambari_server_hostname"

# 3) Fetch an SSL certificate from the Chef Server:

knife ssl fetch

# 4) Print out private DNS names of all the Ambari Agents:
#    (use this info while creating a blueprint AND
#    to substitute hostnames in cluster_creation_template):

ambari_agents_hostnames=$(aws ec2 describe-instances --filters \
  Name=tag:Name,Values=AmbariAgent* \
  Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].{IP:PublicIpAddress}')

for agent in $ambari_agents_hostnames
do
    echo "$agent"
done
