class AuditLog < ApplicationRecord
  belongs_to :company, optional: true

  validates :action, presence: true
  validates :resource_type, presence: true
end
