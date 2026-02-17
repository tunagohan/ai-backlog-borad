class InspectionTemplateSection < ApplicationRecord
  belongs_to :template, class_name: "InspectionTemplate", inverse_of: :sections
  has_many :items, class_name: "InspectionTemplateItem", foreign_key: :section_id, dependent: :destroy, inverse_of: :section

  accepts_nested_attributes_for :items

  validates :name, presence: true
end
