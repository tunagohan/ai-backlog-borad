module Api
  module V1
    class InspectionTemplatesController < ApplicationController
      def index
        templates = InspectionTemplate.includes(sections: :items)
                                      .where(company_id: params[:company_id])
                                      .order(:id)

        render json: templates.map { |template| template_payload(template) }
      end

      def show
        template = InspectionTemplate.includes(sections: :items).find(params[:id])
        render json: template_payload(template)
      end

      def create
        template = nil

        ActiveRecord::Base.transaction do
          template = InspectionTemplate.create!(template_params)

          sections_params.each_with_index do |section, section_index|
            section_record = template.sections.create!(
              name: section[:name],
              sort_order: section.fetch(:sort_order, section_index)
            )

            Array(section[:items]).each_with_index do |item, item_index|
              section_record.items.create!(
                name: item[:name],
                result_type: item[:result_type],
                unit: item[:unit],
                required: item.fetch(:required, true),
                sort_order: item.fetch(:sort_order, item_index)
              )
            end
          end
        end

        template = InspectionTemplate.includes(sections: :items).find(template.id)
        render json: template_payload(template), status: :created
      end

      private

      def template_params
        params.require(:inspection_template).permit(:company_id, :name, :version, :is_active)
      end

      def sections_params
        params.require(:inspection_template).permit(sections: [
          :name,
          :sort_order,
          { items: %i[name result_type unit required sort_order] }
        ]).fetch(:sections, [])
      end

      def template_payload(template)
        {
          id: template.id,
          company_id: template.company_id,
          name: template.name,
          version: template.version,
          is_active: template.is_active,
          sections: template.sections.sort_by(&:sort_order).map do |section|
            {
              id: section.id,
              name: section.name,
              sort_order: section.sort_order,
              items: section.items.sort_by(&:sort_order).map do |item|
                {
                  id: item.id,
                  name: item.name,
                  result_type: item.result_type,
                  unit: item.unit,
                  required: item.required,
                  sort_order: item.sort_order
                }
              end
            }
          end,
          created_at: template.created_at,
          updated_at: template.updated_at
        }
      end
    end
  end
end
