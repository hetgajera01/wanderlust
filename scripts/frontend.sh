#!/bin/bash

INSTANCE_ID="i-00f172de6e4c7d852"

ip_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

env_file="../frontend/.env.sample"

ip_env=$(cat $env_file)

if [[ "$ip_env" != "VITE_API_PATH=\"http://${ip_address}:31100\"" ]]; then
    if [[ -f $env_file ]]
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" $env_file
    
    else
        mkdir $env_file
        sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" $env_file


