class Dashboard < ApplicationRecord
    validates :name, presence: true, length: { minimum: 1 }
    belongs_to :account
end
