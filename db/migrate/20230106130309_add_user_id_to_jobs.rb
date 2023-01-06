class AddUserIdToJobs < ActiveRecord::Migration[7.0]
  def change 
     add_reference :jobs, :users, index:true, null: false, foreign_key: true
     add_reference :events, :jobs, index:true, null: false, foreign_key: true
    
  end
end
