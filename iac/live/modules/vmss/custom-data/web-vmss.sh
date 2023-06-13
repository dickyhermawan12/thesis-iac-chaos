#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs

cd ~
git clone https://github.com/dickyhermawan12/thesis-iac-chaos.git codebase
cd codebase/frontend

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

fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "===> Swapfile created"
cd ~
git clone https://github.com/dickyhermawan12/thesis-iac-chaos.git codebase
cd codebase/frontend
echo "NEXT_PUBLIC_BACKEND_URL=http://localhost:5000" >.env.local
echo "NEXTAUTH_SECRET=thesissecretkey" >>.env.local
echo "===> Installing dependencies and building the app"
npm install
npm run build
echo "===> Setup pm2"
pm2 start npm --name "microblog" -- start
pm2 startup
pm2 save
echo "===> Setup nginx"
rm /etc/nginx/sites-enabled/default
# replace BACKEND_IP_ADDRESS with actual IP address of 15.1.3.5 the backend in nginx.conf
sed -i 's/BACKEND_IP_ADDRESS/15.1.3.5/g' /home/dicky/codebase/frontend/nginx.conf
cp /home/dicky/codebase/frontend/nginx.conf /etc/nginx/sites-enabled/default
systemctl restart nginx
