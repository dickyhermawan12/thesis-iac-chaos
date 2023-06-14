#!/bin/bash
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "===> Swapfile created" >~/log.txt
cd ~
git clone https://github.com/dickyhermawan12/thesis-iac-chaos.git codebase
cd codebase/backend
DB_DRIVER="mysql"
DB_HOST="iac-thesis-mysqlfs-db.mysql.database.azure.com"
DB_PORT="3306"
DB_NAME="microblog"
DB_USER="dicky"
DB_PASS="Administer1212"
SSL_CA="thesisdb.pem"
SECRET_KEY="thesissecretkey"
ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES="150"
cat <<EOF >.env
DB_DRIVER=$DB_DRIVER
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
SSL_CA=$SSL_CA
SECRET_KEY=$SECRET_KEY
ALGORITHM=$ALGORITHM
ACCESS_TOKEN_EXPIRE_MINUTES=$ACCESS_TOKEN_EXPIRE_MINUTES
EOF
echo "===> Installing dependencies" >>~/log.txt
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
echo "===> Setup gunicorn" >>~/log.txt
pip install gunicorn httptools uvloop
cp ~/codebase/backend/gunicorn.service.root /etc/systemd/system/gunicorn.service
systemctl daemon-reload
systemctl start gunicorn
systemctl status gunicorn >>~/log.txt 2>&1
systemctl enable gunicorn
systemctl restart gunicorn
systemctl status gunicorn >>~/log.txt 2>&1
echo "===> Setup nginx" >>~/log.txt
cp ~/codebase/backend/nginx.conf /etc/nginx/sites-enabled/default
systemctl restart nginx
echo "===> Setup completed" >>~/log.txt
