class Asset < ApplicationRecord
  belongs_to :space

  validates :name, presence: true
end
