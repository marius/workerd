class SimpleWorkerd
  def work
    # Or optimistic locking?
    Workpiece.transaction do
      item = Workpiece.next_waiting
      return unless item
      item.execute!
    end
    begin
      item.run
      item.complete!
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
      work if work?
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
