#!/bin/bash
set -e

cat << EOF > /etc/msmtprc
account default
host $SMTP_SERVER
port $SMTP_PORT
tls off
auth off
from "$SMTP_FROM"
logfile /dev/fd/1
EOF

chown root:web /etc/msmtprc
chmod 660 /etc/msmtprc

envsubst '${DOCUMENT_ROOT} ${SERVER_NAME}' < /etc/nginx/sites-available/site.conf.tmpl > /etc/nginx/sites-enabled/site.conf

# Setup Timezone
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

chown -R web:web /var/www
chmod -R 755 /var/www

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
