module Api
  module V1
    class DashboardController < ApplicationController
      def show
        company = Company.find(params[:company_id])
        properties = company.properties.order(:id)

        latest_completed_jobs = InspectionJob.where(
          company_id: company.id,
          target_type: "property",
          status: "completed"
        ).order(scheduled_for: :desc).group_by(&:target_id)

        open_issue_counts = Issue.joins(:job)
                                 .where(company_id: company.id, status: %w[open in_progress])
                                 .where(inspection_jobs: { target_type: "property" })
                                 .group("inspection_jobs.target_id")
                                 .count

        property_summaries = properties.map do |property|
          latest_job = Array(latest_completed_jobs[property.id]).first

          {
            property_id: property.id,
            property_name: property.name,
            latest_inspection_job_id: latest_job&.id,
            latest_inspection_at: latest_job&.completed_at,
            open_issue_count: open_issue_counts[property.id] || 0
          }
        end

        render json: {
          company_id: company.id,
          generated_at: Time.current,
          totals: {
            property_count: properties.count,
            open_issue_count: property_summaries.sum { |summary| summary[:open_issue_count] },
            completed_job_count: InspectionJob.where(company_id: company.id, status: "completed").count
          },
          properties: property_summaries
        }
      end
    end
  end
end
