class CreateWorkpieces < ActiveRecord::Migration
  def self.up
    create_table :workpieces do |t|
      t.string :class_name, :method_name, :null => false
      t.string :argument_hash
      t.integer :state, :default => 0, :null => false
      t.timestamps
    end
    
    add_index :workpieces, :status
  end

  def self.down
    drop_table :workpieces
  end
end
