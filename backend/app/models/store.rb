class Store < ApplicationRecord
  belongs_to :property
  has_many :spaces, dependent: :destroy

  validates :name, presence: true
end
