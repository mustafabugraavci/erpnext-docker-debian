#!/bin/sh
set -e
set -x   # optional: shows all commands in logs

echo "-> Clearing cache"
su frappe -c "bench execute frappe.cache_manager.clear_global_cache"

echo "-> Bursting env into config"
envsubst '$RFP_DOMAIN_NAME' < /home/$systemUser/temp_nginx.conf > /etc/nginx/conf.d/default.conf
envsubst '$PATH,$HOME,$NVM_DIR,$NODE_VERSION' < /home/$systemUser/temp_supervisor.conf > /home/$systemUser/supervisor.conf

echo "-> Starting nginx in foreground"
/usr/sbin/nginx -g 'daemon off;' &   # run in foreground, keep script alive

echo "-> Starting supervisord in foreground"
/usr/bin/supervisord -n -c /home/$systemUser/supervisor.conf
