require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',
                                        :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :workpieces, :force => true do |t|
    t.string :class_name
    t.string :method_name
    t.string :method_argument
    t.integer :state, :default => 0
  end
end

Fixtures.create_fixtures 'test', ActiveRecord::Base.connection.tables
