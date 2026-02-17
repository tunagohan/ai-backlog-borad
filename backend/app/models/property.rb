class Property < ApplicationRecord
  belongs_to :company
  has_many :stores, dependent: :destroy

  validates :name, presence: true
end
