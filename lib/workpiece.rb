class SimpleWorkerd
  class Workpiece < ActiveRecord::Base
    WAITING = 0
    RUNNING = 1
    COMPLETED = 2
    ERROR = 3

    scope :waiting, where("state = #{WAITING}")
    scope :running, where("state = #{RUNNING}")
    scope :completed, where("state = #{COMPLETED}")
    scope :error, where("state = #{ERROR}")

    serialize :method_argument

    def execute!
      update_attribute :state, RUNNING
    end

    def complete!
      update_attribute :state, COMPLETED
    end

    def error!
      update_attribute :state, ERROR
    end

    def run
      class_name.constantize.send(method_name.to_sym, method_argument.clone)
    end
  end
end
