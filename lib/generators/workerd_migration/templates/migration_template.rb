class CreateWorkpieces < ActiveRecord::Migration
  def self.up
    create_table :workpieces, :force => true do |t|
      t.string :class_name, :method_name, :null => false
      t.string :method_argument
      t.integer :state, :default => 0, :null => false
      t.timestamps
    end

    add_index :workpieces, :state
  end

  def self.down
    drop_table :workpieces
  end
end
