module Api
  module V1
    class InspectionJobsController < ApplicationController
      def index
        jobs = InspectionJob.includes(:template)
                            .where(company_id: params[:company_id])
                            .order(scheduled_for: :desc)

        render json: jobs.map { |job| job_payload(job) }
      end

      def show
        job = InspectionJob.includes(:template).find(params[:id])
        render json: job_payload(job)
      end

      def create
        job = InspectionJob.create!(job_params)
        render json: job_payload(job), status: :created
      end

      private

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

      def job_payload(job)
        {
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
          created_at: job.created_at,
          updated_at: job.updated_at
        }
      end
    end
  end
end
