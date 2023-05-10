#!/usr/bin/env bash

sudo apt update -y && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&
  sudo apt-get install -y nodejs

cd ~
git clone https://github.com/dickyhermawan12/cm-intern.git
cd cm-intern/frontend

if ! [ -x "$(command -v node)" ]; then
  echo "Error: node is not installed." >&2
  exit 1
fi

npm install
npm run build
sudo npm install pm2@latest -g

pm2 start npm --name "cm-intern" -- start
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

sudo apt install nginx -y
sudo rm /etc/nginx/sites-enabled/default
sudo cp /home/ubuntu/cm-intern/frontend/nginx.conf /etc/nginx/sites-enabled/default
sudo systemctl restart nginx