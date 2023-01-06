class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, nullable:false
      t.datetime :date_of_event, nullable:false
      t.text :description
      
      t.timestamps
    end
  end
end
