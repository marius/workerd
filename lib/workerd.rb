class Workerd
  cattr_accessor :current_job

  def work
    # Or optimistic locking?
    Workpiece.transaction do
      item = Workpiece.waiting.first :order => id, :lock => true
      return unless item
      item.execute!
    end
    self.class.current_job = item
    begin
      item.run
    rescue Exception => e
      item.error! "#{e.message}\n#{e.backtrace.join("\n")}"
    end
    item.destroy unless item.error?
    self.class.current_job = nil
  end

  def work?
    Workpiece.waiting.size > 0
  end

  def run
    loop do
      while work?
        work
      end
      sleep 2
    end
  end

  def daemonize
    # implement me
  end
end

if __FILE__ == $0
  w = Workerd.new
  w.daemonize
  w.run
end
