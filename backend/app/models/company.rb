class Company < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :inspection_templates, dependent: :destroy
  has_many :inspection_jobs, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :audit_logs, dependent: :destroy

  validates :name, presence: true
end
