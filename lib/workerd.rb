class Workerd
  def work
    # Or optimistic locking?
    Workpiece.transaction do
      item = Workpiece.waiting.first :order => id, :lock => true
      return unless item
      item.execute!
    end
    begin
      item.run
      item.destroy
    rescue Exception => e
      item.error!
      item.error_message = "#{e.message}\n#{e.backtrace.join("\n")}"
      item.save!
    end
  end

  def work?
    Workpiece.waiting.size > 0
  end

  def main
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
  s = SimpleWorkerd.new
  s.daemonize
  s.main
end
