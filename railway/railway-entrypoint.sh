#!/bin/sh
set -e
set -x   # optional: prints each command for logs

echo ">>> ENTRYPOINT START"

# Set ownership of sites folder
echo "-> Setting ownership of sites folder"
chown -R frappe:frappe /home/frappe/bench/sites

# Link built assets
echo "-> Linking assets"
su frappe -c "ln -sf /home/frappe/bench/built_sites/assets /home/frappe/bench/sites/assets"
su frappe -c "ln -sf /home/frappe/bench/built_sites/apps.json /home/frappe/bench/sites/apps.json"
su frappe -c "ln -sf /home/frappe/bench/built_sites/apps.txt /home/frappe/bench/sites/apps.txt"

# Execute CMD (railway-cmd.sh)
exec "$@"
