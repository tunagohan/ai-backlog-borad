class Issue < ApplicationRecord
  belongs_to :company
  belongs_to :job, class_name: "InspectionJob"

  enum :severity, {
    low: "low",
    medium: "medium",
    high: "high"
  }, validate: true

  enum :status, {
    open: "open",
    in_progress: "in_progress",
    closed: "closed"
  }, validate: true

  validates :title, presence: true
end
