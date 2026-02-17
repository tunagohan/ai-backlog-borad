require "csv"

module Api
  module V1
    class DashboardController < ApplicationController
      def show
        company = Company.find(params[:company_id])
        properties = company.properties.order(:id)
        resolution_hours_by_property = build_resolution_hours_by_property(company.id)

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
          avg_resolution_hours = average_hours(resolution_hours_by_property[property.id])

          {
            property_id: property.id,
            property_name: property.name,
            latest_inspection_job_id: latest_job&.id,
            latest_inspection_at: latest_job&.completed_at,
            open_issue_count: open_issue_counts[property.id] || 0,
            avg_resolution_hours: avg_resolution_hours
          }
        end

        payload = {
          company_id: company.id,
          generated_at: Time.current,
          totals: {
            property_count: properties.count,
            open_issue_count: property_summaries.sum { |summary| summary[:open_issue_count] },
            completed_job_count: InspectionJob.where(company_id: company.id, status: "completed").count,
            avg_resolution_hours: average_hours(resolution_hours_by_property.values.flatten)
          },
          properties: property_summaries
        }

        respond_to do |format|
          format.json { render json: payload }
          format.csv { render_csv(payload) }
        end
      end

      private

      def render_csv(payload)
        csv = CSV.generate(headers: true) do |table|
          table << [ "property_id", "property_name", "latest_inspection_job_id", "latest_inspection_at", "open_issue_count", "avg_resolution_hours" ]

          payload[:properties].each do |summary|
            table << [
              summary[:property_id],
              summary[:property_name],
              summary[:latest_inspection_job_id],
              summary[:latest_inspection_at],
              summary[:open_issue_count],
              summary[:avg_resolution_hours]
            ]
          end
        end

        send_data csv, filename: "dashboard_company_#{payload[:company_id]}.csv", type: "text/csv"
      end

      def build_resolution_hours_by_property(company_id)
        grouped = Hash.new { |hash, key| hash[key] = [] }
        Issue.joins(:job)
             .where(company_id: company_id, status: "closed")
             .where.not(reported_at: nil, resolved_at: nil)
             .where(inspection_jobs: { target_type: "property" })
             .pluck("inspection_jobs.target_id", :reported_at, :resolved_at)
             .each do |target_id, reported_at, resolved_at|
          lead_time_hours = ((resolved_at - reported_at) / 1.hour).to_f
          next if lead_time_hours.negative?

          grouped[target_id] << lead_time_hours
        end
        grouped
      end

      def average_hours(values)
        return nil if values.blank?

        (values.sum / values.length).round(2)
      end
    end
  end
end
