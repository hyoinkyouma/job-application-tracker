class ChangeColumnUsersIdToUserIdInJobsTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :jobs, :users_id, :user_id
  end
end
