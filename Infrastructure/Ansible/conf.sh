#!/bin/bash

set -e

ansible master -i hosts.ini -b -m script -a "jenkins-master.sh"
ansible worker -i hosts.ini -b -m script -a "jenkins-node.sh"
