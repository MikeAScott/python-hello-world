#! /bin/bash

# must sudo to run

SITE="helloworld"
TLD =".app"
APP="helloworldapp"
SITE_PATH="/var/www/$SITE"
CONF_FILE="$SITE.conf"


mkdir -p /etc/httpd/sites-available 
mkdir -p /etc/httpd/sites-enabled
mkdir -p $SITE_PATH
mkdir -p $SITE_PATH/logs

cp conf/$CONF_FILE /etc/httpd/sites-available/

if [ ! -f /etc/httpd/sites-enabled/$CONF_FILE ]; then
  ln -s /etc/httpd/sites-available/$CONF_FILE /etc/httpd/sites-enabled/$CONF_FILE
fi

pushd $SITE_PATH
virtualenv venv
source venv/bin/activate
pip3 install -r requirements.txt
popd

cp conf/helloworldapp.wsgi $SITE_PATH/venv/
cp server.py $SITE_PATH/venv/

if ! grep -qF "$SITE.$TLD" /etc/hosts; then
  echo "127.0.0.1 $SITE.$TLD" >> /etc/hosts
fi

chown -R apache:apache $SITE_PATH

systemctl restart httpd