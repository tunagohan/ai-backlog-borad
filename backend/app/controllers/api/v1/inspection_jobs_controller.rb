module Api
  module V1
    class InspectionJobsController < ApplicationController
      def index
        jobs = InspectionJob.includes(template: { sections: :items })
                            .where(company_id: params[:company_id])
                            .order(scheduled_for: :desc)

        render json: jobs.map { |job| job_payload(job, include_template: false) }
      end

      def show
        job = find_job
        render json: job_payload(job, include_template: true)
      end

      def create
        job = InspectionJob.create!(job_params)
        record_audit!(
          company_id: job.company_id,
          action: "inspection_job_created",
          resource_type: "inspection_job",
          resource_id: job.id,
          metadata: { target_type: job.target_type, target_id: job.target_id }
        )
        render json: job_payload(job, include_template: false), status: :created
      end

      def start
        job = find_job
        job.update!(status: :in_progress, started_at: Time.current)
        record_audit!(
          company_id: job.company_id,
          action: "inspection_job_started",
          resource_type: "inspection_job",
          resource_id: job.id
        )
        render json: job_payload(job, include_template: false)
      end

      def save_results
        job = find_job
        items = result_items

        ActiveRecord::Base.transaction do
          items.each do |item|
            result = job.results.find_or_initialize_by(template_item_id: item[:template_item_id])
            result.assign_attributes(
              result_type: item[:result_type],
              result_value: item[:result_value],
              numeric_value: item[:numeric_value],
              comment: item[:comment]
            )
            result.save!
          end
        end

        record_audit!(
          company_id: job.company_id,
          action: "inspection_results_saved",
          resource_type: "inspection_job",
          resource_id: job.id,
          metadata: { results_count: items.count }
        )

        render json: {
          job_id: job.id,
          results_count: job.results.count
        }
      end

      def complete
        job = find_job
        job.update!(status: :completed, completed_at: Time.current)
        record_audit!(
          company_id: job.company_id,
          action: "inspection_job_completed",
          resource_type: "inspection_job",
          resource_id: job.id
        )
        render json: job_payload(job, include_template: false)
      end

      private

      def find_job
        InspectionJob.includes(template: { sections: :items }, results: :template_item).find(params[:id])
      end

      def job_params
        params.require(:inspection_job).permit(
          :company_id,
          :template_id,
          :target_type,
          :target_id,
          :scheduled_for,
          :status
        )
      end

      def result_items
        params.require(:results).map do |item|
          ActionController::Parameters.new(item).permit(
            :template_item_id,
            :result_type,
            :result_value,
            :numeric_value,
            :comment
          )
        end
      end

      def job_payload(job, include_template:)
        payload = {
          id: job.id,
          company_id: job.company_id,
          template_id: job.template_id,
          template_name: job.template&.name,
          target_type: job.target_type,
          target_id: job.target_id,
          status: job.status,
          scheduled_for: job.scheduled_for,
          started_at: job.started_at,
          completed_at: job.completed_at,
          results: job.results.map do |result|
            {
              id: result.id,
              template_item_id: result.template_item_id,
              template_item_name: result.template_item&.name,
              result_type: result.result_type,
              result_value: result.result_value,
              numeric_value: result.numeric_value,
              comment: result.comment
            }
          end,
          created_at: job.created_at,
          updated_at: job.updated_at
        }

        if include_template
          payload[:template] = {
            id: job.template.id,
            name: job.template.name,
            version: job.template.version,
            sections: job.template.sections.sort_by(&:sort_order).map do |section|
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
            end
          }
        end

        payload
      end
    end
  end
end
