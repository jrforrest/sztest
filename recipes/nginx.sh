# Install nginx from a PPA if it is not present
if ! sunzi.installed nginx; then
  sunzi.mute add-apt-repository -y ppa:nginx/stable
  sunzi.mute apt-get -y update
  sunzi.mute apt-get -y install nginx
fi

# Place the site config file if it is not current
if sunzi.file_update files/nginx-site.conf /etc/nginx/sites-enabled/<%= @attributes.app_name %>; then
  [ -f /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default
  echo "Restarting nginx"
  service nginx restart
fi
