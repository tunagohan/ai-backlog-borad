class InspectionJob < ApplicationRecord
  TARGET_TYPES = %w[property store space].freeze

  belongs_to :company
  belongs_to :template, class_name: "InspectionTemplate"
  has_many :results, class_name: "InspectionResult", foreign_key: :job_id, dependent: :destroy
  has_many :issues, class_name: "Issue", foreign_key: :job_id, dependent: :destroy

  enum :status, {
    scheduled: "scheduled",
    in_progress: "in_progress",
    completed: "completed"
  }, validate: true

  validates :target_type, inclusion: { in: TARGET_TYPES }
  validates :target_id, presence: true
  validates :scheduled_for, presence: true
end
