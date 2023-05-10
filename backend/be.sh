#!/usr/bin/env bash

sudo apt update -y && sudo apt upgrade -y

cd ~
git clone https://github.com/dickyhermawan12/cm-intern.git
cd cm-intern/backend

sudo apt install python3-pip python3-venv -y
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

pip install gunicorn httptools uvloop
sudo cp /home/ubuntu/cm-intern/backend/gunicorn.service /etc/systemd/system/gunicorn.service
sudo systemctl daemon-reload
sudo systemctl start gunicorn
sudo systemctl enable gunicorn

sudo apt install nginx -y
sudo rm /etc/nginx/sites-enabled/default
sudo cp /home/ubuntu/cm-intern/backend/nginx.conf /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

