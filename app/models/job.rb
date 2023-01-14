class Job < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, class_name: "User"
    has_many :events, dependent: :delete_all
end
