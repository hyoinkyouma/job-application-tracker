class Job < ApplicationRecord
    belongs_to :users, foreign_key: :users_id
    has_many :events
end
