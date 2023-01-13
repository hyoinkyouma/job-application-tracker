class Event < ApplicationRecord
    belongs_to :job, foreign_key: :job_id, class_name: "Job"
end
