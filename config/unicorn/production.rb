require 'denv'
Denv.load

# paths
app_name = ENV['APP_NAME'] || "app#{ENV['HOSTNAME']}"
app_path = ENV['APP_PATH'] || '/app'
working_directory app_path
pid               "/tmp/#{app_name}_#{ENV['HOSTNAME']}.pid"

# listen
listen ENV['UNICORN_UNIX_SOCKET'] || '/tmp/app.sock'

# logging
logger Logger.new($stdout)

# workers
worker_processes 2

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/Gemfile"
end

# preload
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
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
    ActiveRecord::Base.establish_connection
  end
end

before_exec do |server|
  # cf. http://eagletmt.hateblo.jp/entry/2015/02/21/015956
  Dotenv.overload
end
