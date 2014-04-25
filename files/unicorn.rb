# -*- encoding : utf-8 -*-

app_dir = "/home/<%= @attributes.app_name %>/www/<%= @attributes.app_name %>/current"
log_path = "#{app_dir}/log/unicorn.log"

  unicorn_pid: /home/sztest/www/sztest/current/tmp/pids/unicorn.pid
  unicorn_sock: /tmp/unicorn.sztest.sock
  unicorn_config: /home/sztest/www/sztest/shared/config/unicorn.rb
  unicorn_log: /home/sztest/www/sztest/shared/log/unicorn.log

worker_processes <%= @attributes.unicorn_workers %>
working_directory <%= @attributes.unicorn_working_directory %>
pid <%= @attributes.unicorn_pid %>
stderr_path <%= @attributes.unicorn_log %>
stdout_path <%= @attributes.unicorn_log %>

preload_app true

# Restart any workers that haven't responded in 30 seconds
timeout 30

listen "/tmp/unicorn.<%= @attributes.app_name %>.sock"

before_exec do |server|
  # reload Gemfile
  ENV["BUNDLE_GEMFILE"] = "#{Rails.root}/Gemfile"
end

before_fork do |server, worker|

  # Clear DB Connections. See `after_fork`!
  if defined? ActiveRecord::Base
    # ActiveRecord::Base.connection_handler.clear_all_connections!
    ActiveRecord::Base.connection.disconnect!
  end

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    # ActiveRecord::Base.connection_handler.verify_active_connections!
    ActiveRecord::Base.establish_connection
  end
end

