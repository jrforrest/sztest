# Ensure config dir exists
if sunzi.create_directory $APP_WWW/shared/config; then
  chown -R $APP_USER:devs $APP_WWW/shared
fi

# Ensure unicorn.rb latest
sunzi.file_update files/unicorn.rb <%= @attributes.unicorn_config %> || true

# Esnure init file latest and executable and added to sysvinit
if sunzi.file_update files/unicorn_init /etc/init.d/unicorn_<%= @attributes.app_name %>; then
  chmod +x /etc/init.d/unicorn_<%= @attributes.app_name %>  
  update-rc.d -f unicorn_<%= @attributes.app_name %>
fi
