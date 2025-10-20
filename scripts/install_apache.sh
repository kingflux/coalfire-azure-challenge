#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apache2
systemctl enable apache2
hostname=$(hostname)
echo "Hello from ${hostname}" > /var/www/html/index.html
