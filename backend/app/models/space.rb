class Space < ApplicationRecord
  belongs_to :store
  has_many :assets, dependent: :destroy

  validates :name, presence: true
end
