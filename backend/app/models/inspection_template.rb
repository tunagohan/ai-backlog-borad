class InspectionTemplate < ApplicationRecord
  belongs_to :company
  has_many :sections, class_name: "InspectionTemplateSection", foreign_key: :template_id, dependent: :destroy, inverse_of: :template

  accepts_nested_attributes_for :sections

  validates :name, presence: true
  validates :version, presence: true
end
