#! /bin/bash

# must sudo to run

SITE="helloworld"
TLD="local"
SITE_PATH="/var/www/$SITE"
CONF_FILE="$SITE.conf"
SOURCE=$(pwd)

mkdir -p /etc/httpd/sites-available 
mkdir -p /etc/httpd/sites-enabled
mkdir -p $SITE_PATH
mkdir -p $SITE_PATH/wsgi
mkdir -p $SITE_PATH/logs
semanage fcontext -a -t httpd_sys_rw_content_t $SITE_PATH/logs
restorecon -v $SITE_PATH/logs

# use a2ensite ? a2ensite $CONF_FILE
cp conf/$CONF_FILE /etc/httpd/sites-available/

if [ ! -f /etc/httpd/sites-enabled/$CONF_FILE ]; then
  ln -s /etc/httpd/sites-available/$CONF_FILE /etc/httpd/sites-enabled/$CONF_FILE
fi

/usr/local/bin/virtualenv $SITE_PATH/venv
source $SITE_PATH/venv/bin/activate
pip3 install -r requirements.txt
cp wsgi/helloworldapp.wsgi $SITE_PATH/wsgi/
cp server.py $SITE_PATH/

if ! grep -qF "$SITE.$TLD" /etc/hosts; then
  echo "127.0.0.1 $SITE.$TLD" >> /etc/hosts
fi

chown -R apache:apache $SITE_PATH

systemctl restart httpd
