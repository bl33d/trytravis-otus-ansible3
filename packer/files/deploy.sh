#!/bin/sh
apt install git -y
git clone -b monolith https://github.com/express42/reddit.git /opt/reddit
cd /opt/reddit
bundle install

cat <<EOT >> /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/reddit
ExecStart=//usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl enable puma
