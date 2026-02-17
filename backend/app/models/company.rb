class Company < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :inspection_templates, dependent: :destroy
  has_many :inspection_jobs, dependent: :destroy

  validates :name, presence: true
end
