class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      
      t.string :job_title, null: false
      t.text :job_description
      t.decimal :salary, precision: 9, scale: 2
      t.integer :status
      t.boolean :accepted
      
      t.timestamps
    end
  end
end
