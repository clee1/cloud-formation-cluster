#!/usr/bin/env bash
set -e

function grep_aws {
  aws ec2 $1 | grep $2 | head -n 1 | awk '{ print $2 }' | sed -e 's/\,//g'
}

function grep_subnets {
  grep_aws describe-subnets $1
}

function grep_vpcs {
  grep_aws describe-vpcs $1
}

vpc_id=$(grep_vpcs "VpcId")
subnet_id=$(grep_subnets "SubnetId")
subnet_cidr=$(grep_subnets "CidrBlock")

echo $vpc_id
echo $subnet_id
echo $subnet_cidr

aws cloudformation create-stack \
  --region "us-east-1" \
  --stack-name "HadoopCluster" \
  --template-body file://_cloud_formation_template/HadoopCluster.template \
  --parameters \
    ParameterKey=KeyName,ParameterValue=default \
    ParameterKey=AgentsInstanceTypeParameter,ParameterValue=t2.micro \
    ParameterKey=VpcId,ParameterValue=$vpc_id \
    ParameterKey=SubnetID,ParameterValue=$subnet_id \
    ParameterKey=SubnetCidr,ParameterValue=$subnet_cidr

