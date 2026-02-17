class InspectionResult < ApplicationRecord
  belongs_to :job, class_name: "InspectionJob"
  belongs_to :template_item, class_name: "InspectionTemplateItem"

  validates :result_type, inclusion: { in: InspectionTemplateItem::RESULT_TYPES }
end
