class Notification < ApplicationRecord
  belongs_to :company

  enum :level, {
    info: "info",
    warning: "warning",
    critical: "critical"
  }, validate: true

  validates :title, presence: true
end
