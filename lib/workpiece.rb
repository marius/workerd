class SimpleWorkerd
  class Workpiece < ActiveRecord::Base

    acts_as_state_machine :initial => :waiting
    state :waiting
    state :running
    state :completed
    state :error

    event :execute do
      transitions :from => :waiting, :to => :running
    end

    event :complete do
      transitions :from => :running, :to => :completed
    end

    event :error do
      transitions :from => :running, :to => :error
    end

    serialize :method_argument

    def self.next_waiting
      find_in_state(:first, :waiting, :order => id, :lock => true)
    end

    def run
      class_name.constantize.send(method_name.to_sym, method_argument.clone)
    end
  end
end
