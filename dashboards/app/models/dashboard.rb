class Dashboard < ApplicationRecord
    validates :name, presence: true, length: { minimum: 1 }
    belongs_to :account
    has_many :to_do_tasks
    has_many :in_progress_tasks
    has_many :finished_tasks
end
