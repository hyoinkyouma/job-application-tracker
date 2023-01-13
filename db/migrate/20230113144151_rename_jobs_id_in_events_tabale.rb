class RenameJobsIdInEventsTabale < ActiveRecord::Migration[7.0]
  def change
    rename_column :events, :jobs_id, :job_id
  end
end
