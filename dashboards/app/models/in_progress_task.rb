class InProgressTask < ApplicationRecord
    validates :name, presence: true, length: { minimum: 1, maximum: 30 }
    belongs_to :dashboard
end
