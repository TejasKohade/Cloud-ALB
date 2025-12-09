#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from public instance $(hostname)" > /var/www/html/index.html
