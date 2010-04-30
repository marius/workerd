class Workerd
  @@pidfile = "#{Rails.root}/tmp/pids/workerd.pid"
  cattr_reader :current_workpiece, :pidfile
  @@quit = false

  def work
    item = nil
    Workpiece.transaction do
      item = Workpiece.waiting.first :order => 'id', :lock => true
      return unless item
      item.execute!
    end
    self.class.current_workpiece = item
    begin
      item.run
    rescue Exception => e
      item.error! "#{e.message}\n#{e.backtrace.join("\n")}"
    end
    item.destroy unless item.error?
    self.class.current_workpiece = nil
  end

  def work?
    Workpiece.waiting.size > 0
  end

  def run
    loop do
      while work? and not @@quit
        work
      end
      exit if @@quit
      sleep 2
    end
  end

  def start
    daemonize
    File.open(@@pidfile, 'w') { |f| f.write(Process.pid.to_s) }
    at_exit { File.delete(@@pidfile) if File.exist?(@@pidfile) }
    trap('TERM') { @@quit = true }
    # daemonize kills the db connection
    ActiveRecord::Base.connection.reconnect!
    run
  end

  private

  def daemonize
    if RUBY_VERSION < '1.9'
      exit if fork
      Process.setsid
      exit if fork
      Dir.chdir '/'
      File.umask 0000
      STDIN.reopen '/dev/null'
      STDOUT.reopen '/dev/null', 'a'
      STDERR.reopen '/dev/null', 'a'
    else
      Process.daemon
    end
  end
end
