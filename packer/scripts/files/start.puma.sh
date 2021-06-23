#!/bin/bash

cat > /etc/systemd/system/puma.service <<EOF
[Unit]
Description=Puma service
After=mongod.service
[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/usr/local/bin/puma
TimeoutSec=300
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl start puma
systemctl enable puma
