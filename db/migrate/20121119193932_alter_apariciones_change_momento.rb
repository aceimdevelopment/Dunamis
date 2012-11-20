class AlterAparicionesChangeMomento < ActiveRecord::Migration
  def self.up
    change_column :apariciones, :momento, :datetime
  end

  def self.down
    change_column :apariciones, :momento, :time
  end
end