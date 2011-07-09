class Workerd
  class Workpiece < ActiveRecord::Base
    WAITING = 0
    RUNNING = 1
    ERROR = 2

    scope :waiting, where("state = #{WAITING}")
    scope :running, where("state = #{RUNNING}")
    scope :error, where("state = #{ERROR}")

    # Does not work. AR only serializes Date, Time, Hash and Array
    #serialize :method_arguments

    def method_arguments=(arg)
      @attributes['method_arguments'] = arg.to_yaml
    end

    def method_arguments
      YAML.load @attributes['method_arguments'] if @attributes['method_arguments']
    end

    def execute!
      update_attributes! :state => RUNNING
    end

    def error!(msg)
      update_attributes! :error_message => msg, :state => ERROR
    end

    def error?
      state == ERROR
    end

    def run
      if @attributes['method_arguments']
        class_name.constantize.send(method_name.to_sym, *method_arguments)
      else
        class_name.constantize.send(method_name.to_sym)
      end
    end
  end
end
