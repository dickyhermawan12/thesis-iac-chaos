#!/bin/bash
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "===> Swapfile created" >~/log.txt
cd ~
git clone https://github.com/dickyhermawan12/thesis-iac-chaos.git codebase
cd codebase/frontend
echo "NEXT_PUBLIC_BACKEND_URL=https://iac-thesis-microblog.australiacentral.cloudapp.azure.com/api" >.env.local
echo "NEXTAUTH_SECRET=thesissecretkey" >>.env.local
echo "===> Installing dependencies and building the app" >>~/log.txt
npm install >~/trail.txt 2>&1
npm run --silent build >>~/trail.txt 2>&1
echo "===> Setup pm2" >>~/log.txt
HOME="/root"
export HOME
pm2 list >>~/trail.txt 2>&1
pm2 start npm --name "microblog" -- start >>~/trail.txt 2>&1
pm2 startup >>~/trail.txt 2>&1
pm2 save
echo "===> Setup nginx" >>~/log.txt
sed -i 's/BACKEND_IP_ADDRESS/10.1.4.100/g' ~/codebase/frontend/nginx.conf
cp ~/codebase/frontend/nginx.conf /etc/nginx/sites-enabled/default
systemctl restart nginx
echo "===> Setup completed" >>~/log.txt
