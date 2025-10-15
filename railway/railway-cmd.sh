#!/bin/sh
set -e
set -x   # optional: prints each command for logs

echo ">>> CMD START"

# Clear ERPNext cache
echo "-> Clearing cache"
su frappe -c "bench execute frappe.cache_manager.clear_global_cache"

# Inject environment variables into config files
echo "-> Bursting env into config"
envsubst '$RFP_DOMAIN_NAME' < /home/frappe/temp_nginx.conf > /etc/nginx/conf.d/default.conf
envsubst '$PATH,$HOME,$NVM_DIR,$NODE_VERSION' < /home/frappe/temp_supervisor.conf > /home/frappe/supervisor.conf

# Start nginx in foreground (so container stays alive)
echo "-> Starting nginx in foreground"
nginx -g 'daemon off;' &

# Start supervisord in foreground
echo "-> Starting supervisord in foreground"
/usr/bin/supervisord -n -c /home/frappe/supervisor.conf
