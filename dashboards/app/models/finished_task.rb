class FinishedTask < ApplicationRecord
    validates :name, presence: true, length: { minimum: 1 }
    validates :finishDate, presence: true
    belongs_to :dashboard
end
