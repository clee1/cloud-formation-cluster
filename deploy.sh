#!/usr/bin/env bash
set -e
export AWS_DEFAULT_OUTPUT="text"

# Set the location of your AWS EC2 private key here:
aws_key=~/default.pem

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
    ParameterKey=ChefServerInstanceTypeParameter,ParameterValue=t2.medium \
    ParameterKey=VpcId,ParameterValue=$vpc_id \
    ParameterKey=SubnetID,ParameterValue=$subnet_id \
    ParameterKey=SubnetCidr,ParameterValue=$subnet_cidr

# 1) Configure the Chef Server:

function configure_chef_server {
  # Fill out these variables below.
  # For help see the "Standalone" section, list items 5 and 6 here: https://docs.chef.io/install_server.html
  username=stevedanno
  first_name=Steve
  last_name=Danno
  email=steved@chef.io
  password='abc123'
  short_org_name=4thcoffee
  full_org_name='Fourth Coffee, Inc.'

  function describe_chef_server_fqdn {
    chef_server_fqdn=$(aws ec2 describe-instances --filters \
      Name=tag:Name,Values=ChefServer \
      Name=instance-state-name,Values=running \
      --query 'Reservations[*].Instances[*].{IP:PublicDnsName}')
  }
  describe_chef_server_fqdn

  while [ -z $chef_server_fqdn ]; do
    sleep 30
    echo Waiting chef_server_fqdn
    describe_chef_server_fqdn
  done

  ssh -i $aws_key "ec2-user@$chef_server_fqdn chef-server-ctl user-create $username $first_name $last_name $email '$password' --filename /home/ec2-user/$user.pem"
  ssh -i $aws_key "ec2-user@$chef_server_fqdn chef-server-ctl org-create $short_org_name '$full_org_name' --association_user $username --filename /home/ec2-user/$short_org_name-validator.pem"
  scp -i $aws_key "ec2-user@$chef_server_fqdn:$user.pem ./.chef/"
  scp -i $aws_key "ec2-user@$chef_server_fqdn:$short_org_name-validator.pem ./.chef/"

  sed ./.chef/knife.rb -i.old -e \
    "s/<CHEF_SERVER_URL>/$chef_server_fqdn/g;
     s/<NODE_NAME>/$username/g;
     s/<CLIENT_KEY>/$username.pem/g;
     s/<ORGANIZATION_NAME>/$short_org_name/g"
}
configure_chef_server

# 2) Set information about ip and domain name of the Ambari Server:

function describe_ambari_server_ip {
  ambari_server_ip=$(aws ec2 describe-instances --filters \
    Name=tag:Name,Values=AmbariServer \
    Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].{IP:PublicIpAddress}')
}

function describe_ambari_server_fqdn {
  ambari_server_fqdn=$(aws ec2 describe-instances --filters \
    Name=tag:Name,Values=AmbariServer \
    Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].{IP:PublicDnsName}')
}

describe_ambari_server_ip
describe_ambari_server_fqdn

while [ -z $ambari_server_ip ]; do
  sleep 30
  echo Waiting ambari_server_ip and ambari_server_fqdn
  describe_ambari_server_ip
  describe_ambari_server_fqdn
done

sed ./data_bags/nodes/ambari-server.json -i.old -e "s/<AMBARI_SERVER_IP>/$ambari_server_ip/g; s/<AMBARI_SERVER_HOSTNAME>/$ambari_server_fqdn/g"

# 3) Fetch an SSL certificate from the Chef Server:

echo knife ssl fetch

# 4) Print out private DNS names of all the Ambari Agents:
#    (use this info while creating a blueprint AND
#    to substitute hostnames in cluster_creation_template):

function describe_ambari_agents_fqdns {
  ambari_agents_fqdns=$(aws ec2 describe-instances --filters \
    Name=tag:Name,Values=AmbariAgent* \
    Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].{IP:PublicIpAddress}')
}
describe_ambari_agents_fqdns

while [ -z $ambari_agents_fqdns 2> /dev/null ]; do
  sleep 30
  echo Waiting ambari_agents_fqdns
  describe_ambari_agents_fqdns
done

for agent in $ambari_agents_fqdns
do
    echo "$agent"
done
