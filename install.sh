#! /bin/bash

# must sudo to run

SITE="flaskhelloworldsite.com"
APP="helloworldapp"
SITE_PATH="/var/www/$SITE"
CONF_FILE="$SITE.conf"


mkdir -p /etc/httpd/sites-available 
mkdir -p /etc/httpd/sites-enabled
mkdir -p /var/www/FLASKAPPS/$APP
mkdir -p $SITE_PATH
mkdir -p $SITE_PATH/logs

cp conf/$CONF_FILE /etc/httpd/sites-available/

if [ ! -f /etc/httpd/sites-enabled/$CONF_FILE ]; then
  ln -s /etc/httpd/sites-available/$CONF_FILE /etc/httpd/sites-enabled/$CONF_FILE
fi

cp conf/helloworldapp.wsgi /var/www/FLASKAPPS/$APP/
cp __init__.py /var/www/FLASKAPPS/$APP/

if ! grep -qF "$SITE" /etc/hosts; then
  echo "127.0.0.1 $SITE" >> /etc/hosts
fi

chown -R apache:apache $SITE_PATH

systemctl restart httpd