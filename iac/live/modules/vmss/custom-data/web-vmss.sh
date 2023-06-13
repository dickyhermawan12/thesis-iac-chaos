#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&
  sudo apt-get install -y nodejs

cd ~
git clone https://github.com/dickyhermawan12/thesis-iac-chaos.git codebase
cd codebase/frontend

if ! [ -x "$(command -v node)" ]; then
  echo "Error: node is not installed." >&2
  exit 1
fi

npm install
npm run build
sudo npm install pm2@latest -g

pm2 start npm --name "microblog" -- start
pm2 startup
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u dicky --hp /home/dicky
pm2 save

sudo apt install nginx -y
sudo rm /etc/nginx/sites-enabled/default
sudo cp /home/dicky/codebase/frontend/nginx.conf /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
