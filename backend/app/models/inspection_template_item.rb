class InspectionTemplateItem < ApplicationRecord
  RESULT_TYPES = %w[pass_fail numeric].freeze

  belongs_to :section, class_name: "InspectionTemplateSection", inverse_of: :items

  validates :name, presence: true
  validates :result_type, inclusion: { in: RESULT_TYPES }
end
