#!/bin/bash

set -e

sudo apt update -y
sudo apt install fontconfig openjdk-21-jre -y
java -version 