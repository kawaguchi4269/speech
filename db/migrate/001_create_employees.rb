class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
    end

    create_table :speeches do |t|
      t.datetime :speech_at
      t.references :employee
    end
  end
end
