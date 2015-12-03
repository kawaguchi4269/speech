class CreateSpeeches < ActiveRecord::Migration
  def up
    create_table :speeches do |t|
      t.datetime :speech_at
      t.references :employee
    end
  end

  def down
    drop_table :speeches
  end
end
