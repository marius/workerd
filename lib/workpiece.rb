class Workerd
  class Workpiece < ActiveRecord::Base
    WAITING = 0
    RUNNING = 1
    ERROR = 2

    scope :waiting, where("state = #{WAITING}")
    scope :running, where("state = #{RUNNING}")
    scope :error, where("state = #{ERROR}")

    serialize :method_argument

    def execute!
      update_attribute :state, RUNNING
    end

    def error!
      update_attribute :state, ERROR
    end

    def run
      class_name.constantize.send(method_name.to_sym, method_arguments.clone)
    end
  end
end
