namespace :workerd do
  desc 'Run workerd in foreground'
  task :run => :environment do
    Workerd.new.run
  end

  desc 'Start the background worker'
  task :start => :environment do
    Workerd.new.start
  end

  desc 'Stop the background worker after finishing the current job'
  task :stop => :environment do
    begin
      Process.kill('TERM', File.read(Workerd.pidfile).to_i)
    rescue Errno::ENOENT
      puts 'was not running'
    end
  end
end
